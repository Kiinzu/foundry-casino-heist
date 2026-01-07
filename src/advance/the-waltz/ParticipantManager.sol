// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./BonusDistributor.sol";

contract ParticipantManager{
    BonusDistributor public bd;

    struct Participant{
        string name;
        address addr;
        uint256 bonus;
        uint256 lastClaimed;
    }

    struct RegisterParticipant{
        string name;
        address addr;
    }

    uint256 constant BASIC_BONUS = 1 ether;
    uint8 public nextParticipant;
    address public lastParticipantClaim;
    
    mapping(uint8 => Participant) public participants;

    error invalidParticipant();
    error notOriginalParticipant();
    error noBonusToClaim();
    error multipleClaimAttempt();
    error DistributionFailed();
    error notDirectRegistration();
    error maximumParticipantReached();

    constructor() payable {
        bd = new BonusDistributor{value: msg.value}();
    }

    function registerParticipant(RegisterParticipant memory _participant) external returns(uint8 participantId){
        if(msg.sender == address(0)) revert invalidParticipant();
        if(msg.sender != _participant.addr) revert notDirectRegistration();
        if(nextParticipant == 3) revert maximumParticipantReached(); 
        participantId = nextParticipant++;
        participants[participantId] = Participant({
            name: _participant.name,
            addr: _participant.addr,
            bonus: BASIC_BONUS,
            lastClaimed: 0
        });
    }

    function claimBonus(uint8 _participantId) external {
        Participant storage p = participants[_participantId]; 
        if(p.addr != msg.sender) revert notOriginalParticipant();
        if(p.bonus <= 0 ) revert noBonusToClaim();
        if(p.lastClaimed == block.timestamp && p.addr == lastParticipantClaim) revert multipleClaimAttempt();
        
        p.lastClaimed = block.timestamp;
        lastParticipantClaim = msg.sender;

        (bool success) = bd.distributeBonus(p.bonus, p.addr);
        if(!success) revert DistributionFailed();
        p.bonus = 0;
    }

}