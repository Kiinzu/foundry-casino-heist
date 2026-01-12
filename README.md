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

5. To Test if the challenge is solved, simply run `make` - Since there are challenges that can be deployed and challenge that can be solve only using the Testfile, there are different way to play and solve the challenge

```shell
# Example of Foundry Test Challenge
# Example for vip_bank-of-people (Test)

$ make vip_bank-of-people

# Example of Deployed Challenge (Anvil)
# Example for deploy_basic_briefing
# Deploying Briefing in Local Anvil, will return credential for player

$ make deploy_basic_briefing 
> == Logs ==
  ========== DEPLOYING SETUP ==========
  Setup deployed at: 0x5FbDB2315678afecb367f032d93F642f64180aa3
  ====================================
  
  ========== PLAYER SETUP ==========
  Player Address    :  0x70997970C51812dc3A010C7d01b50e0d17dc79C8
  Player Private Key:  40606737760334725431406512677033654118342507952694270066784247067953537247501
  Player Balance    :  1 ether
  ====================================

$ make solve_basic_briefing
> == Logs ==
    ========== CHECKING SOLUTION ==========
    Setup at          :  0x5FbDB2315678afecb367f032d93F642f64180aa3
    First Celebrator  :  0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
    Balance of Express:  0
    STATUS: NOT SOLVED
    ========================================
  [X] Challenge not solved yet
  [!] Destroying the Challenge Instance
```

7. That's it! You good to go.

## Make List 

Some challenges in Casino Heist are designed to be played on a **deployed Anvil Instance** using Foundry, while others can be solved in test mode or in their **deployed form**.

The table below litst the available modes for each challenge — **deployed**, **test**, or **both** — along with the **recommended way to play** each challenge.

| ///////////////////// | Test                         | Deployed                | Recommended |
| --------------------- | ---------------------------- | ----------------------- | ----------- |
| Briefing              | basic_briefing               | deploy_basic_briefing   |             |
| Bulls Eye             | basic_bulls-eye              |                         |             |
| Gearing Up            | basic_gearing-up             | deploy_basic_gearing-up |             |
| Isolated              | basic_isolated               |                         |             |
| Peek A Slot           | basic_peek-a-slot            |                         |             |
| After You             | -                            | common_after-you        |             |
| Bar                   | common_bar                   |                         |             |
| Casino Vault          | common_casino-vault          |                         |             |
| Cheap Glitch          | common_cheap-glitch          |                         |             |
| Entry Point           | common_entry-point           |                         |             |
| Gorengan              | common_gorengan              |                         |             |
| Inju Bank             | common_inju-bank             |                         |             |
| Master of Blackjack   | common_master-of-blackjack   |                         |             |
| Roulette              | common_roulette              |                         |             |
| Silent Dealer         | common_silent-dealer         |                         |             |
| Singular Identity     | common_singular-identity     |                         |             |
| Symbol of Noble       | common_symbol-of-noble       |                         |             |
| Take My Money         | common_take-my-money         |                         |             |
| Unlimited Credit Line | common_unlimited-credit-line |                         |             |
| Voting Frenzy         | common_voting-frenzy         |                         |             |
| VVVIP Member          | common_vvvip-member          |                         |             |
| Casino Bankbuster     | advance_casino-bankbuster    |                         |             |
| Double Dipping        | advance_double-dipping       |                         |             |
| False Hope            | advance_false-hope           |                         |             |
| Guardian              | advance_guardian             |                         |             |
| Salt and Steel        | -                            | advance_salt-and-steel  |             |
| The Waltz             | advance_the-waltz            |                         |             |
| Bank of People        | vip_bank-of-people           |                         |             |
| Executive Problems    | vip_executive-problems       |                         |             |
| Inju's Gambit         | vip_inju-gambit              |                         |             |
| IPWD                  | vip_ipwd                     |                         |             |
| Pupol BFT             | vip_pupol-nft                |                         |             |
