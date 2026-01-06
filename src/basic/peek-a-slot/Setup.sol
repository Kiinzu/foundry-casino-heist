pragma solidity 0.8.30;

contract Setup{

    bytes32 private hiderOne;
    bytes32[] private hiderTwo;
    bytes32[][] private hiderThree;
    bool public allHidersFound;

    constructor(bytes32 _hider, bytes32[] memory _hiderTwo, bytes32[][] memory _hiderThree) {
        hiderOne = _hider;
        hiderTwo =  _hiderTwo;
        hiderThree = _hiderThree;
    }

    function foundHider(bytes32 _hiderOne, bytes32 _hiderTwo, bytes32 _hiderThree) public {
        if(
            (keccak256(abi.encodePacked(hiderOne)) == keccak256(abi.encodePacked(_hiderOne))) &&
            (keccak256(abi.encodePacked(hiderTwo[4])) == keccak256(abi.encodePacked(_hiderTwo))) &&
            (keccak256(abi.encodePacked(hiderThree[2][3])) == keccak256(abi.encodePacked(_hiderThree))) 
        ){
            allHidersFound = true;
        }
    }

    function isSolved() public view returns(bool){
        return allHidersFound;
    }

}