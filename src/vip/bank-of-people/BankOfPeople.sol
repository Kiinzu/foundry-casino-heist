// SPDX-License-Identifier: NQDU
pragma solidity 0.8.29;

import {BOPUtils} from "./BOPUtils.sol";
import {BOPLockedProxy} from "./BOPCore/BOPLockedProxy.sol";
import {BOPLockedAccount} from "./BOPCore/BOPLockedAccount.sol";
import {BOPIsolatedProxy} from "./BOPCore/BOPIsolatedProxy.sol";
import {BOPIsolatedAccount} from "./BOPCore/BOPIsolatedAccount.sol";

contract BankOfPeople{
    BOPCentral public bopCentral;
    mapping(address => Customer) public customers;
    mapping(address => uint256) public loanAmount;

    address private owner;
    uint256 public loanedOnHold;

    uint8 constant MAX_CUSTOMER = 10;
    uint8 constant BOP_NORMAL_STATUS = 1;
    uint8 constant BOP_LOCKDOWN = 2;
    uint8 constant BOP_FAILING = 0;
    uint8 constant BOP_MIN_HEALTH = 60;
    uint8 constant BOP_STARTING_HEALTH = 100;
    uint8 constant MAX_WITHDRAWAL_PERCENTAGE = 10;
    uint8 constant PERCENTAGE_DENOMINATOR = 100;
    uint8 constant MAX_LOCKED_ACCOUNT = 12;
    uint8 constant MAX_ISOLATED_ACCOUNT = 12;
    uint256 constant WITHDRAWAL_LOCKPERIOD = 3600;
    uint256 constant MIN_FIRST_DEPOSIT = 10 ether;
    uint256 constant REGISTRATION_FEE = 10 ether;
    uint256 constant MIN_OVERALL_BALANCE = 100 ether;
    uint256 constant MIN_LOCKED_PERIOD = 2592000; 

    struct BOPCentral{
        uint8 bopCustomer;
        uint8 bopStatus;
        uint8 bopHealth;
        uint8 bopLastRegisteredLockedAccount;
        uint8 bopLastRegisteredIsolatedAccount;
        uint256 currentFundHolding;
        uint256 lockPeriod;
        mapping(uint8 => LockedAccount) registeredLockedAccount;
        mapping(uint8 => IsolatedAccount) registeredIsolatedAccount;
    }

    struct Customer {
        uint256 balance;
        uint256 lockPeriod;
        bool isCustomer;
    }

    struct LockedAccount {
        address addr;
        uint256 balance;
        uint256 lockPeriod;
    }

    struct IsolatedAccount {
        address addr;
        uint256 balance;
    }

    event CustomerRegistered(address indexed customer);
    event CustomerFirstDeposit(address indexed customer, uint256 amount);
    event CustomerDepositSuccess(address indexed customer, uint256 amount);
    event CustomerWithdrawalSuccess(address indexed customer, uint256 amount, uint256 currentBalance, uint256 lockPeriod);
    event CustomerOpenedLockedAccount(address indexed customer);
    event CustomerOpenedIsolatedAccount(address indexed customer);

    modifier restrictionCheck() {
        if(msg.sender != tx.origin){
            revert("BOPRestriction-CODE-01: Interaction request not from origin!");
        }
        _;
    }

    modifier normalCheck() {
        if(bopCentral.bopStatus != BOP_NORMAL_STATUS){
            revert("BOPRestriction-CRIS-03: BOP is not on Normal Status, please wait a moment.");
        }
        _;
    }

    modifier lockdownCheck() {
        if(bopCentral.bopStatus == BOP_LOCKDOWN){
            revert("BOPRestriction-CRIS-02: Action is not allowed, currently on LOCKDOWN PERIOD");
        }
        _;
    }

    modifier crisisCheck() {
        if(bopCentral.bopStatus != BOP_FAILING){
            revert("BOPRestriction-CRIS-01: Not currently Available. Only Available during Crisis Period.");
        }
        _;
    }

    modifier compatibleReceiver(uint256 _amount, address _requester) {
        bool validation = BOPUtils.checkOnWithdrawalReceiver(_amount, _requester);
        require(validation, "BOP-RECV: Not a compatible receiver!");
        _;
    }

    modifier universalHealthCheck() {
        (uint16 isolatedHealthStatus, uint8 totalIsolatedAccount) = _isolatedAccountHealthChecker();
        (uint16 lockedHealthStatus, uint8 totalLockedAccount )= _lockedAccountHealthChecker();
        uint16 overallAverageHealth = (isolatedHealthStatus + lockedHealthStatus) / 2; 
        bopCentral.bopHealth = uint8(overallAverageHealth);
        if(bopCentral.bopHealth <= BOP_MIN_HEALTH){
            bopCentral.bopStatus = BOP_FAILING;
        }
        _;
    }

    constructor(
        uint256 _funding,
        uint8 _preRegisteredLockedAccount,
        uint8 _preRegisteredIsolatedFund
    ) payable{
        require(_funding == msg.value, "Initialization Error: Funding mismatch");
        bopCentral.currentFundHolding = msg.value;
        if(bopCentral.currentFundHolding < MIN_OVERALL_BALANCE){
            revert("Initialization Error: Not Enough Funding for initialization");
        }
        bopCentral.bopCustomer = 0;
        bopCentral.bopStatus = BOP_NORMAL_STATUS;
        bopCentral.bopHealth = BOP_STARTING_HEALTH;
        bopCentral.bopLastRegisteredLockedAccount = 0;
        bopCentral.bopLastRegisteredIsolatedAccount = 0;

        for(uint8 i = 0; i < _preRegisteredLockedAccount; i++){
            _registerForLockedAccount(i);
        }

        for(uint8 i = 0; i < _preRegisteredIsolatedFund; i++){
            _registerForIsolatedAccount(i);
        }
    }

    function registerCustomer() external payable restrictionCheck{
        require(customers[msg.sender].isCustomer == false, "BOPRestriction-AUTH-01: Sender have previously registered.");
        require(bopCentral.bopCustomer + 1 < MAX_CUSTOMER, "BOPRestriction-NUMB-01: Max Customer Reached");
        require(msg.value == REGISTRATION_FEE, "BOPRestriction-PAYM-01: Fee is not correct.");
        Customer storage customer = customers[msg.sender];
        customer.balance = 0;
        customer.lockPeriod = 0;
        customer.isCustomer = true;
        bopCentral.bopCustomer++;
        bopCentral.currentFundHolding += msg.value;
        emit CustomerRegistered(msg.sender);
    }

    function depositFunds() external payable lockdownCheck restrictionCheck{
        require(customers[msg.sender].isCustomer == true, "BOPRestriction-AUTH-02: Sender is not Customer Registered.");
        bool firstDeposit;
        if(customers[msg.sender].balance == 0){
            require(msg.value >= MIN_FIRST_DEPOSIT, "BOPRestriction-BANK-01: Minimum First Deposit not met.");
            firstDeposit = true;
        }
        bopCentral.bopStatus = BOP_LOCKDOWN;
        Customer storage customer = customers[msg.sender];
        uint256 preDepositBalance = customer.balance;
        customer.balance += msg.value;
        bopCentral.currentFundHolding += msg.value;
        uint256 postDepositBalance = customer.balance;
        require(preDepositBalance + msg.value == postDepositBalance, "BOPRestriction-BANK-02: Post Deposit Value mismatch.");
        require(address(this).balance == bopCentral.currentFundHolding, "BOPRestriction-BANK-03: Post Action Value mismatch");
        bopCentral.bopStatus = BOP_NORMAL_STATUS;
        if(firstDeposit){
            emit CustomerFirstDeposit(msg.sender, msg.value);
        }else{
            emit CustomerDepositSuccess(msg.sender, msg.value);
        }
    }

    function withdrawFunds(uint256 _amount) external lockdownCheck restrictionCheck{
        // only can withdraw maximum 10% of their current balance
        require(customers[msg.sender].isCustomer == true, "BOPRestriction-AUTH-02: Sender is not Customer Registered.");
        Customer storage customer = customers[msg.sender];
        uint256 maximumWithdrawal = customer.balance * MAX_WITHDRAWAL_PERCENTAGE / PERCENTAGE_DENOMINATOR;
        require(_amount <= maximumWithdrawal, "BOPRestriction-BANK-03: Withdrawal exceeding 10% of maximum withdraw");
        require(_amount <= customer.balance, "BOPRestriction-BANK-04: Withdrawal exceeding Customer Balance.");
        if(customer.lockPeriod != 0){
            require(customer.lockPeriod <= block.timestamp, "BOPRestriction-BANK-05: Withdrawal still on cooldown.");
        }
        bopCentral.bopStatus = BOP_LOCKDOWN;
        uint256 preWithdrawBalance = customer.balance;
        uint256 preWithdrawBankHolding = bopCentral.currentFundHolding;
        customer.balance -= _amount;
        bopCentral.currentFundHolding -= _amount;
        uint256 postWithdrawBalance = customer.balance;
        uint256 postWithdrawBankHolding = bopCentral.currentFundHolding;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "BOPRestriction-TRFR-01: Transfer Failed");
        require(preWithdrawBalance - _amount == postWithdrawBalance, "BOPRestriction-BANK-04: Post Withdrawal Value mismatch");
        require(preWithdrawBankHolding - _amount == postWithdrawBankHolding, "BOPRestriction-BANK-03: Post Action Value mismatch");
        customer.lockPeriod = block.timestamp + WITHDRAWAL_LOCKPERIOD;
        bopCentral.bopStatus = BOP_NORMAL_STATUS;
        emit CustomerWithdrawalSuccess(msg.sender, _amount, customer.balance, customer.lockPeriod);
    }

    function alleWithdraw(uint256 _amount) external crisisCheck restrictionCheck compatibleReceiver(_amount, msg.sender){
        Customer storage customer = customers[msg.sender];
        require(customer.balance >= _amount, "BOPRestriction-MORE-01: Withdrawing More than owned amount");
        bopCentral.currentFundHolding -= _amount;
        payable(msg.sender).call{value: _amount}("");
        customer.balance = 0;
    }

    function applyForLoan(uint256 _amount) external normalCheck universalHealthCheck restrictionCheck compatibleReceiver(_amount, msg.sender){
        require(_amount <= bopCentral.currentFundHolding, "BOPRestriction-FUNDS-01: Exceeding Loan Request");
        loanAmount[msg.sender] += _amount;
        loanedOnHold += _amount;
    }

    function applyForLockedAccount() external payable normalCheck restrictionCheck{
        require(customers[msg.sender].isCustomer == true, "BOPRestriction-AUTH-02: Sender is not Customer Registered.");
        require(msg.value == 5 ether, "BOPRestriction-ISAT-01: Application Fee not match!");
        bopCentral.currentFundHolding += msg.value;
        require(bopCentral.bopLastRegisteredLockedAccount < MAX_LOCKED_ACCOUNT, "BOPRestriction-NUMB-02: Max Locked Account Managed Reached");
        _registerForLockedAccount(bopCentral.bopLastRegisteredLockedAccount);
        emit CustomerOpenedLockedAccount(msg.sender);
    }


    function applyForIsolatedAccount() external payable normalCheck restrictionCheck{
        require(customers[msg.sender].isCustomer == true, "BOPRestriction-AUTH-02: Sender is not Customer Registered.");
        require(msg.value == 10 ether, "BOPRestriction-ISAT-01: Application Fee not match!");
        bopCentral.currentFundHolding += msg.value;
        require(bopCentral.bopLastRegisteredIsolatedAccount < MAX_ISOLATED_ACCOUNT, "BOPRestriction-NUMB-03: Max Isolated Account Managed Reached");
        _registerForIsolatedAccount(bopCentral.bopLastRegisteredIsolatedAccount);
        emit CustomerOpenedIsolatedAccount(msg.sender);
    }

    function _registerForLockedAccount(uint8 _id) internal {
        BOPLockedAccount laImplementation = new BOPLockedAccount(MIN_LOCKED_PERIOD);
        BOPLockedProxy lProxy = new BOPLockedProxy(address(laImplementation));
        bopCentral.registeredLockedAccount[_id] = LockedAccount(
            address(lProxy),
            0,
            MIN_LOCKED_PERIOD
        );
        bopCentral.bopLastRegisteredLockedAccount++;
        BOPIsolatedAccount(address(lProxy)).initialize();
    }

    function _registerForIsolatedAccount(uint8 _id) internal {
        BOPIsolatedAccount iaImplementation = new BOPIsolatedAccount();
        BOPIsolatedProxy iProxy = new BOPIsolatedProxy(
            address(iaImplementation)
        );
        bopCentral.registeredIsolatedAccount[_id] = IsolatedAccount(
            address(iProxy),
            0
        );
        bopCentral.bopLastRegisteredIsolatedAccount++;
        BOPIsolatedAccount(address(iProxy)).initialize();
    }

    function _isolatedAccountHealthChecker() public view returns(uint16 result, uint8 totalIsolatedAccount) {
        totalIsolatedAccount = bopCentral.bopLastRegisteredIsolatedAccount;
        uint8 totalHealth = 0;
        for (uint8 i = 0 ; i < totalIsolatedAccount ; i++){
            IsolatedAccount storage isolatedAccount = bopCentral.registeredIsolatedAccount[i];
            bool status = BOPIsolatedAccount(isolatedAccount.addr).accountStatus();
            if(status) {
                totalHealth++;
            }
        }
        result = (uint16(totalHealth) * 100) / totalIsolatedAccount;
    }

    function _lockedAccountHealthChecker() public view returns(uint16 result, uint8 totalLockedAccount) {
        totalLockedAccount = bopCentral.bopLastRegisteredIsolatedAccount;
        uint8 totalHealth = 0;
        for (uint8 i = 0 ; i < totalLockedAccount ; i++){
            LockedAccount storage lockedAccount = bopCentral.registeredLockedAccount[i];
            bool status = lockedAccount.balance >= 0 ? true : false;
            if(status) {
                totalHealth++;
            }
        }
        result = (uint16(totalHealth) * 100) / totalLockedAccount;
    }

}
