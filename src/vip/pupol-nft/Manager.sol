// SPDX-License-Identifier: INJU
pragma solidity ^0.8.28;

import "./PupolMain.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Manager {
    PupolMain public pupol;

    uint256 public PRICE_FOR_PUPOL;

    constructor(
        address _pupolMain,
        uint256 _pupolPrice
    ) {
        pupol = PupolMain(_pupolMain);
        PRICE_FOR_PUPOL = _pupolPrice;
    }

    function claimNFT() external payable{
        require(msg.value == PRICE_FOR_PUPOL);
        pupol.mint(msg.sender);
    }

    function transferNFT(address _to, uint256 _pupolId) external {
        require(_to != address(0x0));
        require(pupol.getOwnerAddress(_pupolId) == msg.sender, "Can only transfer owned Pupol");
        pupol.transferPupol(msg.sender, _to, _pupolId);
    }

    function claimPupolOwnerBonus() external {
        pupol.claimPupolBonus(msg.sender);
    }

    function setApprovedForAll(address _operator, bool _status) public {
        pupol.setApprovalForAll(_operator, _status);
    }

    function isApprovedForAll(address _operator) public view returns(bool){
        return pupol.isApprovedForAll(msg.sender, _operator);
    }

}