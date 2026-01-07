// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./AncientVault.sol";
import "forge-std/console2.sol";

abstract contract FireGate {
    function keyOfFire() public view virtual returns (bytes32) {
        return keccak256(abi.encodePacked(
            "May fire be hell unleashed",
            address(this),
            uint256(1111)
        ));
    }
}

abstract contract WaterGate {
    function keyOfWater() public view virtual returns (bytes32) {
        return keccak256(abi.encodePacked(
            "May tides remember every step", 
            address(this),
            uint256(2222)
        ));
    }
}

abstract contract WindGate {
    function keyOfWind() public view virtual returns (bytes32) {
        return keccak256(abi.encodePacked(
            "May the unseen carry your will",
            address(this),
            uint256(3333)
        ));
    }
}

abstract contract EarthGate {
    function keyOfEarth() public view virtual returns (bytes32) {
        return keccak256(abi.encodePacked(
            "May stone bear witness to truth",
            address(this), 
            uint256(4444)
        ));
    }
}

abstract contract LightGate {
    function keyOfLight() public view virtual returns (bytes32) {
        return keccak256(abi.encodePacked(
            "May light reveal what is hidden",
            address(this), 
            uint256(5555)
        ));
    }
}

abstract contract DarkGate{
    function keyOfDark() public view virtual returns (bytes32) {
        return keccak256(abi.encodePacked(
            "May darkness know your name",
            address(this), 
            uint256(6666)
        ));
    }
}

contract Guardian is FireGate, WaterGate, WindGate, EarthGate, LightGate, DarkGate{

    AncientVault public av;

    bool public fireGateOpen;
    bool public waterGateOpen;
    bool public windGateOpen;
    bool public earthGateOpen;
    bool public lightGateOpen;
    bool public darkGateOpen;
    bool public ancientVaultOpen;

    error onlyOneSelfMustComeForward();
    error fireGateCloseInstantly();
    error waterGateCloseInstantly();
    error windGateCloseInstantly();
    error earthGateCloseInstantly();
    error lightGateCloseInstantly();
    error darkGateCloseInstantly();
    error vaultRemainClosed();

    modifier unveiled(){
        if(msg.sender != tx.origin) revert onlyOneSelfMustComeForward();
        _;
    }

    modifier allGateOpened(){
        _;
        if(
            fireGateOpen &&
            waterGateOpen &&
            windGateOpen &&
            earthGateOpen &&
            lightGateOpen &&
            darkGateOpen 
        ) ancientVaultOpen = true;
    }

    modifier vaultRemainSealed(){
        if(!ancientVaultOpen) revert vaultRemainClosed();
        _;
    }

    constructor() payable {
        av = new AncientVault{value: msg.value}();
    }

    function accessAncientVault() public unveiled vaultRemainSealed{
        av.claimTreasure(msg.sender);
    }

    function confrontTheFireGate() external unveiled allGateOpened{
        if(
            FireGate(address(msg.sender)).keyOfFire() == keyOfFire()
        ){
            fireGateOpen = true;
            return;
        }
        revert fireGateCloseInstantly();
    }

    function confrontTheWaterGate() external unveiled allGateOpened{
        if(
            WaterGate(address(msg.sender)).keyOfWater() == keyOfWater()
        ){
            waterGateOpen = true;
            return;
        }
        revert waterGateCloseInstantly();
    }

    function confrontTheWindGate() external unveiled allGateOpened{
        if(
            WindGate(address(msg.sender)).keyOfWind() == keyOfWind()
        ){
            windGateOpen = true;
            return;
        }
        revert windGateCloseInstantly();
    }

    function confrontTheEarthGate() external unveiled allGateOpened{
        if(
            EarthGate(address(msg.sender)).keyOfEarth() == keyOfEarth()
        ){
            earthGateOpen = true;
            return;
        }
        revert earthGateCloseInstantly();
    }

    function confrontTheLightGate() external unveiled allGateOpened{
        if(
            LightGate(address(msg.sender)).keyOfLight() == keyOfLight()
        ){
            lightGateOpen = true;
            return;
        }
        revert lightGateCloseInstantly();
    }

    function confrontTheDarkGate() external unveiled allGateOpened{
        if(
            DarkGate(address(msg.sender)).keyOfDark() == keyOfDark()
        ){
            darkGateOpen = true;
            return;
        }
        revert darkGateCloseInstantly();
    }

}