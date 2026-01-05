pragma solidity 0.8.30;

contract Setup{

    bytes32 private hiderOne;
    bytes32[] private hiderTwo;
    bytes32[][] private hiderThree;
    bytes32 private validHiderOne;
    bytes32 private validHiderTwo;
    bytes32 private validHiderThree;
    bool public allHidersFound;

    constructor(bytes32 _hider, bytes32[] memory _hiderTwo, bytes32[][] memory _hiderThree) {
        hiderOne = validHiderOne = _hider;
        hiderTwo =  _hiderTwo;
        validHiderTwo = hiderTwo[4];
        hiderThree = _hiderThree;
        validHiderThree = hiderThree[2][3];
    }

    function foundHider(bytes32 _hiderOne, bytes32 _hiderTwo, bytes32 _hiderThree) public {
        if(
            (keccak256(abi.encodePacked(validHiderOne)) == keccak256(abi.encodePacked(_hiderOne))) &&
            (keccak256(abi.encodePacked(validHiderTwo)) == keccak256(abi.encodePacked(_hiderTwo))) &&
            (keccak256(abi.encodePacked(validHiderThree)) == keccak256(abi.encodePacked(_hiderThree))) 
        ){
            allHidersFound = true;
        }
    }

    function isSolved() public view returns(bool){
        return allHidersFound;
    }

}