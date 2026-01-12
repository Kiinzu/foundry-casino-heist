// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./Isolation.sol";

contract Setup{
    Isolation isolated;
    Isolation isolated2;
    Isolation isolated3;
    Isolation isolated4;
    Isolation isolated5;

    constructor() payable {
        isolated = new Isolation(); 
        for (uint i=0; i<126; i++){ 
            new Isolation();  
        } 
        isolated2 = new Isolation(); 
        isolated3 = new Isolation(); 
        for (uint256 i=0; i < 894; i++){
            new Isolation();
        }
        isolated4 = new Isolation(); 
        for(uint256 i=0; i<64511; i++){
            new Isolation();
        } 
        isolated5 = new Isolation();
    }   

    function isSolved() public view returns(bool){
        return (
            isolated.found() && isolated2.found() && isolated3.found() && isolated4.found() && isolated5.found()
        );
    }
}