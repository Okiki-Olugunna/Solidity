// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Collectible {
    
    address payable owner;

    event Deployed(address indexed _owner);

    constructor() {
        owner = payable(msg.sender);
        emit Deployed(msg.sender);
    }


    modifier onlyOwner {
        require(owner == msg.sender, "You are not the owner of this collectible");
        _;
    }

    event Transfer(address indexed _init_owner, address indexed _new_owner);

    function transfer(address payable _recipient) external onlyOwner {
        owner = _recipient;
        emit Transfer(msg.sender, _recipient);
    }

    uint price; // defaults to 0

    //bool forSale;

    event ForSale(uint _price, uint _blocktimestamp);

    function markPrice(uint _askprice) public onlyOwner {
        price = _askprice;
        emit ForSale(_askprice, block.timestamp);
    }
    
    modifier purchaseMod {
        require(price > 0, "Must be greater than 0.");
        require(msg.value == price, "You need to pay more for this mate.");
        _;
    }

    event Purchase(uint _purchaseamount, address indexed _buyer);

    function purchase() external payable purchaseMod {
        //forSale = false;
        price = 0;
        owner.transfer(msg.value);
        owner = payable(msg.sender);
        
        emit Purchase(msg.value, msg.sender);
    }

}
