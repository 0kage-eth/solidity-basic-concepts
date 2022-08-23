//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


/**
 * @dev Student struct defined with id and class
 */
struct Student {
    uint256 id;
    uint8 class;    
}

/**
 * @dev library called Class defined
 * @dev defined functions upgradeClass and downgradeClass
 */
library Class {
    
    /**
     * @dev storage is used for _person
     * @dev in this case, changing _person changes the storage happen on the contract that use this library
     * @dev this is because a pointer to storage is passed into function - library by itself does not have any state variables or storage
     * @dev self here refers to the storage pointer 
     */
    function upgradeClass(Student storage self, uint8 _jump) external {
        self.class += _jump;
    }

    function downgradeClass(Student storage self, uint8 _jump) external {
        self.class -= _jump;
    }
}

/**
 * @dev Section contract uses library 
 * @dev note that we are using the `using..for` syntac
 * @dev we could have also used library functions direcyly
 * 
 */
contract Section{

    // this is how we assign the functions to the Student struct defined above

    using Class for Student;

    mapping(address => Student) public s_database;

    uint256 public s_ctr;

    function add(uint256 _id, uint8 _class) public{
        s_database[msg.sender].id = _id;
        s_database[msg.sender].class = _class;
    }

    function upgrade(uint8 _upgrade) public {
        s_database[msg.sender].upgradeClass(_upgrade);
    }

    function downgrade(uint8 _downgrade) public {
        s_database[msg.sender].downgradeClass(_downgrade);
    }
}

/**
 * @dev in this contract I access library without `using..for`
 * @dev although we can use this way, above method is cleaner and recommended
 * 
 */
contract SectionWithoutUsing{
    mapping(address => Student) public s_database;

    uint256 public s_ctr;

    function add(uint256 _id, uint8 _class) public {
        s_database[msg.sender].id = _id;
        s_database[msg.sender].class = _class;
    }

    // In this case we directly called function from Class Library
    
    function upgrade(uint8 _upgrade) public {
        Class.upgradeClass(s_database[msg.sender], _upgrade);
    }


    function downgrade(uint8 _downgrade) public {
        Class.downgradeClass(s_database[msg.sender], _downgrade);
    }



}