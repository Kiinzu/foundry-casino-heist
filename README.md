## Foundry Casino Heist

![Logo](./foundry-casino-heist.png)

A Collection of Casino Heist's Challenges written in Foundry- Perfect for those who doesn't want to deploy anything and want to exercise their Test Writting skill in Foundry.

You can find the reading material in our website at [Casino Heist](https://casinoheist.enuma-labs.xyz).

## Requirement

What you need to prepare:

1. [Foundry](https://book.getfoundry.sh/)
2. Snacks 🍫🍪

All the libraries such as [Openzepplin Contracts](https://docs.openzeppelin.com/upgrades-plugins/foundry-upgrades) is already included in the GitHub Repository.

## Mini-Guide

This is the directory and its usage.

- `/src` - all vulnerable contracts here.
- `/test` - all test files
- `/reading-mats/docs` - all vulnerabilities Explanation (Archived Version from CasinoHeist.v0)
- `/reading-mats/Mithrough` - all Mitigations & Walkthroughs (Archived Version from CasinoHeist.v0)

## How to Play

1. Clone the Repository

```shell
git clone https://github.com/Kiinzu/foundry-casino-heist.git`
cd /foundry-casino-heist
forge install
```

2. You will find the Challenge in the `/src` accordingly to their Category.

   - Basic (Introductory)
   - Common (Common Vulnerabilities)
   - VIP (Easier Stuff, trust me)
3. You will find all the test in one folder `/test` (Basic, Common, VIP in one place).
4. Some might require you to write Exploit Contract, some you can just edit the Test Directly. There will be `// Write Exploit Here`, that's the only place you should edit and some may include `vm.warp()`, you might also want to change this if you think you need it.

```solidity
// Example: test/MasterOfBlackjack.t.sol
    function testIfSolved() public {
        // Setup for Player
        vm.startPrank(player, player);
        vm.deal(player, 1 ether);

        // Write Exploit here
        vm.warp(19); // Feel free to change this to any block.timestamp that satisfy the requirement

        vm.stopPrank();
        assertEq(challSetup.isSolved(), true);
    }
```

⚠️ - **Do Not Change the Setup for player!**

5. To Test if the challenge is solved, simply run `make` 

```shell
// Example for vip_bank-of-people
make vip_bank-of-people

// OR
// Example for all challenge test
make test-all
```

7. That's it! You good to go.
