pragma solidity ^0.8.30;

import "./Range.sol";

contract Setup {

    Range public range;

    constructor() payable {
        range = new Range{value: 10 ether}();
    }

    function isSolved() public view returns(bool){
        return address(range).balance == 0;
    }

}