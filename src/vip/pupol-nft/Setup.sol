// SPDX-License-Identifier: INJU
pragma solidity ^0.8.28;

import "./Manager.sol";
import "./PupolMain.sol";

contract Setup{
    PupolMain public pupol;
    Manager public manager;

    constructor() payable{
        pupol = new PupolMain{value: 1000 ether}(5 ether, 1000 ether);
        manager = new Manager(address(pupol), 10 ether);
        
        pupol.setManagerContract(address(manager));
    }

    function isSolved() public view returns(bool){
        return address(pupol).balance < 100 ether;
    }

}