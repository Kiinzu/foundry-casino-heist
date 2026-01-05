pragma solidity ^0.8.30;

contract Range{

    bool public targetOneHit;
    bool public targetTwoHit;
    bool public targetThreeHit;

    constructor() payable {}

    receive() external payable {
        targetTwoHit = true;
    }

    fallback() external payable {
        targetThreeHit = true;
    }

    function targetOne() public payable {
        require(msg.value == 1 ether, "You've missed the Target!");
        targetOneHit = true;
    }

    function claimBounty() public {
        if(
            targetOneHit &&
            targetTwoHit &&
            targetThreeHit
        ){
            (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
            require(success, "Failed to Transfer Bounty");
        }
    }

}