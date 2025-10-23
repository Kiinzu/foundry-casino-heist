// SPDX-License-Identifier: INJU
pragma solidity ^0.8.28;

import "./Manager.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PupolMain is ERC721, Ownable, ReentrancyGuard{
    
    uint256 public pupolId = 1;
    uint256 public bonusPerPupol;
    uint256 public bonusInventory;

    address public managerContractAddress;

    bool public allowAllContracts;

    mapping(address => uint256) public claimedBonus;

    constructor(
        uint256 _bonusPerPupol,
        uint256 _bonusAllocation
    ) ERC721("Pupol NFT", "PUPOL") Ownable(msg.sender) payable {
        bonusPerPupol = _bonusPerPupol;
        bonusInventory = _bonusAllocation;
        allowAllContracts = true;
    }

    // Mint Function
    function mint(address _mintTo) external onlyManagerContract nonReentrant{
        uint256 newPupolId = pupolId++;
        _safeMint(_mintTo, newPupolId);
        
    }

    function transferPupol(
        address _from,
        address _to,
        uint256 _pupolId
    ) public {
        if(msg.sender != managerContractAddress){
            require(isApprovedForAll(_msgSender(), _to), "ERC721: transfer caller is not owner nor approved");
        }
        _finalCheckBeforeTransfer(_from, _to);
        _safeTransfer(_from, _to, _pupolId, "");
    }

    function claimPupolBonus(address _owner) external onlyManagerContract{
        require(balanceOf(_owner) > 0, "Need to Own Pupol to claim reward!");
        _claimPupolBonus(_owner);
    } 

    // Owner Only Function
    function setManagerContract(address _managerContract) public onlyOwner{
        managerContractAddress = _managerContract;
    }

    function setAllowContracts(bool _condition) external onlyOwner{
        allowAllContracts = _condition;
    }

    // getter function
    function getOwnerAddress(uint256 _pupolId) public view returns(address){
        return ownerOf(_pupolId);
    } 

    function getPendingPupolOwnershipBonus(address _owner) public view returns(uint256){
        return (balanceOf(_owner) * (bonusPerPupol - claimedBonus[_owner]));
    }


    // Replacement for isContract
    function isContract(address _addr) internal view returns(bool) {
        return tx.origin == _addr ;

    }

    // Internal Funcions
    function _claimPupolBonus(address _owner) internal nonReentrant{
        uint256 bonusToPay = getPendingPupolOwnershipBonus(_owner);
        if(bonusToPay > 0 ){
            bonusInventory = bonusInventory - bonusToPay;
            claimedBonus[_owner] = bonusPerPupol;
            (bool sent, ) = address(_owner).call{value: bonusToPay}("");
            require(sent);
        }
    }

    function _finalCheckBeforeTransfer(
        address _from,
        address _to
    ) internal {
        if(_from != address (0x0)){
            _claimPupolBonus(_from);

            // if it's _from last NFT
            if(balanceOf(_from) == 1){
                delete claimedBonus[_from];
            }
        }

        // If the _to already has NFTs, claim their rewards
        if(balanceOf(_to) > 0){
            _claimPupolBonus(_to);
        }else{
            claimedBonus[_to] = bonusPerPupol;
        }
    }

    modifier onlyManagerContract{
        require(msg.sender == managerContractAddress, "Only Manager is Allowed to Interact");
        _;
    }


}