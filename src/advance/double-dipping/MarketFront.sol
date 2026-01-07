// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./Inventory.sol";
import "./IERC3156.sol";

contract MarketFront{
    Inventory public inventory;

    bytes32 internal constant CALLBACK_SUCCESS =
        keccak256("ERC3156FlashBorrower.onFlashLoan");

    address public owner;
    uint256 public feeBps = 5;

    mapping(address=>uint256) public storeCredit;

    error OnlyOwner();
    error InsufficientLiquidity();
    error UnsupportedToken();
    error NotRepaid();
    error CallbackFailed();
    error DepositMismatch();

    modifier onlyOwner(){
        if(msg.sender != owner) revert OnlyOwner();
        _;
    }

    constructor(address _owner) payable {
        owner = _owner;
    }

    function purchaseStoreCredit(address _receiver, uint256 _amount) external payable{
        if(msg.value != _amount) revert DepositMismatch();
        storeCredit[_receiver] += msg.value;
    }

    function buyItem(uint8 _itemId, uint8 _quantity) public payable{
        uint256 paidAmount = msg.value;
        address buyer = msg.sender;
        inventory.buyItem((_itemId), buyer, paidAmount, _quantity);
    }

    function maxFlashLoan(address token) external view returns (uint256) {
        if (token != address(0)) return 0;
        return address(this).balance;
    }

    function flashFee(address token, uint256 amount) public view returns (uint256) {
        if (token != address(0)) revert UnsupportedToken();
        return (amount * feeBps) / 10_000;
    }

    function flashloan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool) {
        if (token != address(0)) revert UnsupportedToken();
        if (amount > address(this).balance) revert InsufficientLiquidity();

        uint256 fee = flashFee(token, amount);
        uint256 balBefore = address(this).balance;

        (bool ok,) = address(receiver).call{value: amount}("");
        require(ok, "ETH transfer failed");

        bytes32 ret = receiver.onFlashLoan(msg.sender, token, amount, fee, data);
        if (ret != CALLBACK_SUCCESS) revert CallbackFailed();

        if (address(this).balance < balBefore + fee) revert NotRepaid();

        return true;
    }

    function setInventory(address _inventory) external onlyOwner{
        inventory = Inventory(_inventory);
    }

}