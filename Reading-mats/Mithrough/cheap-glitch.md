## Mitigation

Now that you've successfully completed the heist, we will learn how to fix the problem that you just encountered. First of all, we notice that the contract is already using Solidity version *0.8.26* and can be compiled with the latest version, so the version here is not the problem; the problem seems to lie in the *unchecked*, and let's add some more check &nbsp;  
&nbsp;  

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Capitol{
    
    bool public isRicher;
    address public owner;
    mapping(address => uint256) public balanceOf;

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = 1_000_000_000 ether;
    }

    function depositCredit(uint256 _amount) public payable{
        require(_amount > 1 ether, "Minimum deposit is 1 ether");
        require(msg.value == _amount, "There seems to be a mismatch!");
        // Remove the unchecked{}
        balanceOf[msg.sender] += _amount;
    }

    function withdrawCredit(uint256 _amount) public{
        require(_amount > 0, "Must be greater than zero!");
        require(balanceOf[msg.sender] - _amount >= 0, "You don't have this kind of money");
        // Remove the unchecked{}
        balanceOf[msg.sender] -= _amount;
    }

    function richerThanOwner() public{
        // The Casino is Not that stupid, they know that the balance beyond that is CHEATING!
        if(balanceOf[msg.sender] < 10_000_000_000_000 ether && balanceOf[msg.sender] > balanceOf[owner]){
            isRicher = true;
        }
    }
}
```
&nbsp;  
The mitigation above seems enough to fix the vulnerability. There is also another way to make the operation more secure; we can use *OpenZeppelin's SafeMath* library. Here is a little example for the *depositCredit()* function that also uses the *SafeMath* library. &nbsp;  
&nbsp;  

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Capitol {
    using SafeMath for uint256;  // Use SafeMath for uint256 operations

    bool public isRicher;
    address public owner;
    mapping(address => uint256) public balanceOf;

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = 1_000_000_000 ether;
    }

    function depositCredit(uint256 _amount) public payable {
        require(_amount > 1 ether, "Minimum deposit is 1 ether");
        require(msg.value == _amount, "There seems to be a mismatch!");
        // SafeMath addition
        balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
    }

    function withdrawCredit(uint256 _amount) public {
        require(_amount > 0, "Must be greater than zero!");
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance!");
        // SafeMath subtraction
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
    }

    function richerThanOwner() public {
        require(
            balanceOf[msg.sender] < 10_000_000_000_000 ether,
            "Invalid balance, suspicious activity!"
        );

        if (balanceOf[msg.sender] > balanceOf[owner]) {
            isRicher = true;
        }
    }
}
```

## Walkthrough

We know that from the *Setup.sol* we need to make the *Capitol::isRicher()* bool returns true; in order to do this, we need to call the *Capitol::richerThanOwner()*  
&nbsp;  
```solidity
function richerThanOwner() public{
    // The Casino is Not that stupid, they know that the balance beyond that is CHEATING!
    if(balanceOf[msg.sender] < 10_000_000_000_000 ether && balanceOf[msg.sender] > balanceOf[owner]){
        isRicher = true;
    }
}
```
&nbsp;   
Based on the code, it will make the *Capitol::isRicher()* true if our balance is greater than the owner itself and it's not greater than *10_000_000_000_000 ether*, because it's ether, so add another 18 zero. Now let's see the whole code to see where we can make this possible.  
&nbsp;  
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Capitol{
    
    bool public isRicher;
    address public owner;
    mapping(address => uint256) public balanceOf;

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = 1_000_000_000 ether;
    }

    function depositCredit(uint256 _amount) public payable{
        require(_amount > 1 ether, "Minimum deposit is 1 ether");
        require(msg.value == _amount, "There seems to be a mismatch!");
        unchecked{
            balanceOf[msg.sender] += _amount;
        }
    }

    function withdrawCredit(uint256 _amount) public{
        require(_amount > 0, "Must be greater than zero!");
        unchecked{
            balanceOf[msg.sender] -= _amount;
        }
    }

    function richerThanOwner() public{
        // The Casino is Not that stupid, they know that the balance beyond that is CHEATING!
        if(balanceOf[msg.sender] < 10_000_000_000_000 ether && balanceOf[msg.sender] > balanceOf[owner]){
            isRicher = true;
        }
    }
}
```
&nbsp;   
Looking from the Solidity version *^0.8.26*, Arithmetic overflow-underflow is most likely impossible, but wait, there is *unchecked{}* in both *Capitol::depositCredit()* and *Capitol::withdrawCredit()*, this means the input *uint256 _amount* will be processed  regardless if it's going to overflow or underflow the value of *balanceOf[msg.sender]* by the end of the operation because they are unchecked!
&nbsp;  
&nbsp;  
Furthermore, in *Capitol::withdrawCredit*, there is no check whether the amount that we are going to withdraw is exceeding our current balance or not, so we don't have to deposit anything to withdraw. Now calculating the correct amount so that our balance is less than *10_000_000_000_000 ether*, in this walkthrough we are going to create a simple function in Solidity and run it.  
&nbsp;  
```solidity

pragma solidity ^0.8.26;

contract Calculate{
    function calculate() public pure returns(uint256){
        return type(uint256).max - 10_000_000_000_000 ether + 2;
    }
}
``` 
&nbsp;  
In Solidity we can get the max value of a data type using *type(<datatype>).max* just like the code above, to get the max value of uint256. We simply calculate the distance between the max from the target and add 2 at the end, why 2? Notice that our balance start from *0*, meaning we need to *-1* so that our balance becomes the max number an uint256 can hold, then another *-1* to make sure we are below the *10_000_000_000_000 ether* mark, the function will return a large number that will make our balance *9_999_999_999_999 ether*. 