// SPDX-License-Identifier: MIT

/// @notice SPDX license identifier shows that source code is licensed under MIT

pragma solidity ^0.8.7;
/// @notice pragma solidity specifies the version of solidity

/**
 * /// @title Simple storage contract to understand basis
 /// @author Sushant Reddy
 /// @notice Using this contract, we undestand concepts of contracts
 /// @dev get/set functions, return, view, mapping and data types
 */

// Here I define a new contract called Simple Storage

// Contract is a set of code & data that resides at a specific address on blockchain

contract SimpleStorage {
    uint private storedData; // define a public storage variable
    // we declare a state variable storedData of type uint
    // we can think of this as a database with a single slot - we can query or write data into this single slot database
    // defining it as private makes it inaccessible to other contracts

    /// @dev getStoredData() is a get function that returns value of storedData on chain
    /// 'public' makes it accessible to users/contracts on chain
    /// 'view' makes it a read-only, no gas is consumed to run this method

    function getStoredData() public view returns(uint){
       return storedData;
    }

    /// @dev setStoredData() is a set function that takes in an input _data
    /// returns a boolean type
    /// updates the state of storage variable - this will need consensus on chain - and hence will need gas to execute
    function setStoredData(uint _data) public returns(bool){

        storedData = _data;
        return true;
    } 
}

