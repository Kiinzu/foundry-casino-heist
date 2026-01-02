pragma solidity ^0.8.13;

import "./Bouncer.sol";

contract Setup {

    Bouncer public bouncer;

    constructor() { 
        bouncer = new Bouncer();
    }

    function isSolved() public view returns(bool){
        return address(bouncer).balance > 0;
    }
}