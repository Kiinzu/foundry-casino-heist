pragma solidity ^0.8.13;

contract Bouncer{

    uint256 public total_tips;

    constructor(){}

    function tips_bouncer(uint256 _amount) public {
        require(_amount > 0, "No Tips?");
        total_tips+= _amount;
    }

}