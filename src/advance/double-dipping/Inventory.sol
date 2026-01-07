// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {MarketFront} from "./MarketFront.sol";

contract Inventory{
    MarketFront public MF;

    struct Item{
        string name;
        uint256 price;
        uint8 inStock;
        bool onSale;
    }

    address public owner;
    uint8 public nextItemId;

    mapping(uint8 => Item) public items;
    mapping(address => mapping(uint8 => uint256)) public bought;

    error OnlyOwner();
    error OnlyMarketFront();
    error InvalidItem();
    error NotOnSale();
    error OutOfStock();
    error WrongPrice();

    modifier onlyOwner() {
        if(msg.sender != owner) revert OnlyOwner();
        _;
    }

    modifier onlyMF() {
        if(msg.sender != address(MF)) revert OnlyMarketFront();
        _;
    }

    constructor(address _mf){
        owner = msg.sender;
        MF = MarketFront(_mf);
    }

    function inputItem(Item calldata _item) external onlyOwner{
        if(bytes(_item.name).length == 0) revert InvalidItem();
        if(_item.price == 0) revert InvalidItem();
        if(_item.inStock == 0) revert InvalidItem();

        uint8 itemId = nextItemId++;
        items[itemId] = Item({
            name: _item.name,
            price: _item.price,
            inStock: _item.inStock,
            onSale: true
        });
    }

    function setOnSale(uint8 _itemId, bool _onSale) external onlyOwner{
        if(_itemId >= nextItemId) revert InvalidItem();
        items[_itemId].onSale = _onSale;
    }

    function addStock(uint8 _itemId, uint8 _supply) external onlyOwner{
        if(_itemId >= nextItemId) revert InvalidItem();
        items[_itemId].inStock += _supply;
    }

    function buyItem(uint8 _itemId, address _buyer, uint256 _paidAmount, uint8 _quantity) external onlyMF{
        Item storage it = items[_itemId];
        uint256 totalPrice = it.price * _quantity;
        if (bytes(it.name).length == 0) revert InvalidItem();
        if (!it.onSale) revert NotOnSale();
        if (it.inStock == 0) revert OutOfStock();
        if (_paidAmount != totalPrice) revert WrongPrice();

        it.inStock -= _quantity;
        bought[_buyer][_itemId] += _quantity;
    }

}