// SPDX-License-Identifier: MIT 

pragma solidity ^0.6.0;

contract SimpleStorage {

    // this initialises the favourite number to 0
    uint256 favouriteNumber;

    // structs are ways of creating new types, i.e new objects 
    struct People {
        uint256 favouriteNumber;
        string name;
    }

    // People public person = People({favouriteNumber: 7, name: "Okiki"});

    // setting the visibility to public, because without it the visibility is automatically 'internal'
    // this allows other people to read the variable 
    // arrays can be dynamic, or fixed size 
    People[] public people;

    mapping(string => uint256) public nameToFavouriteNumber;

    function store(uint256 _num) public {
        favouriteNumber = _num;
    }

    // view functions and pure functions don't make transactions (they don't create a state change) 
    // pure functions are functions that purely do some kind of math 

    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }

    /* when you use a paramenter that's going to be a string for one of your functions
    you need to call it string memory */
    function addPerson(string memory _name, uint256 _favouriteNum) public {
        people.push(People({favouriteNumber: _favouriteNum, name: _name}) );
        nameToFavouriteNumber[_name] = _favouriteNum;
    }
    
}