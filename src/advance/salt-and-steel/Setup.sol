// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface ISteel {
    function companyMotto() external view returns (string memory);
    function companyMission() external view returns (string memory);
}

// Interface for SteelFactory contract
interface ISteelFactory {
    function forgeSteel() external returns (ISteel);
    function getSteelAddress() external view returns (address);
}

contract Setup {
    ISteelFactory public steelFactory;
    ISteel public steel;
    
    address public player;

    bool public firstPhase;
    bool public secondPhase;
    bool public thirdPhase;

    error notPlayer();
    error firstPhaseNotCleared();
    error secondPhaseNotCleared();

    modifier onlyPlayer() {
        if(msg.sender != player) revert notPlayer();
        _;
    }

    constructor(address _player) {
        player = _player;
    }

    function setSteelFactory(address _factory, address _steel) external onlyPlayer{
        steelFactory = ISteelFactory(_factory);
        steel = ISteel(_steel);
    }
    
    function firstPhaseCheck() external onlyPlayer{
        string memory res = steel.companyMotto();
        if(
            keccak256(abi.encodePacked("Finn & Co Steel Company.")) == keccak256(abi.encodePacked(res)) &&
            address(steel).code.length != 0
        ){
            firstPhase = true;
            return;
        }
    }

    function secondPhaseCheck() external onlyPlayer{
        if(!firstPhase) revert firstPhaseNotCleared();
        if(address(steel).code.length == 0){
            secondPhase = true;
            return;
        }
    }

    function thirdPhaseCheck() external onlyPlayer{
        string memory res = steel.companyMission();
        if(!secondPhase) revert secondPhaseNotCleared();
        if(
            keccak256(abi.encodePacked("To Forge the Finest Steel of all.")) == keccak256(abi.encodePacked(res)) &&
            address(steel).code.length != 0
        ){
            thirdPhase = true;
            return;
        }
    }

    function isSolved() public view returns (bool) {
        return (
            firstPhase && secondPhase && thirdPhase
        );
    }

}