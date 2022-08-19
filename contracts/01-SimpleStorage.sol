/**
 *  @dev SPDX license identifier shows that source code is licensed under MIT
 * */ 
// SPDX-License-Identifier: MIT


/**
 * @dev pragma solidity specifies the version of solidity
 * @dev ^ denotes that any version above 0.8.7 will be able to comiple code
 */
pragma solidity ^0.8.7;

/**
 * @title Simple storage contract to understand basics
 * @author 0Kage
 * @notice Using this contract, we undestand concepts of contracts
 * @dev get/set functions, return, view, mapping and data types
 * @dev contract is a set of code & data that resides at a specific address on blockchain
 */
contract SimpleStorage {

    /**
     * @dev we declare a state variable storedData of type uint
     * @dev this is stored in storage & hence data will be persistent
     * @dev we can think of this as a database with a single slot - we can query or write data into this single slot database
     * @dev 'private' denotes storage is inaccessible outside the contract
     * @dev 
     */
    uint private storedData; 


    /**
     * @dev getStoredData is a get function that returns value of storedData on chain
     * @dev function does not change state on blockchain & hence does not consume gas
     * @dev 'public' here denotes that this function is stored at a location that can be accessed by other addresses
     * @dev 'view' tag indicates it is a read-only function that doesn't write to the blockchain
     */

    function getStoredData() public view returns(uint){
       return storedData;
    }

    /**
     * @dev setStoredData is a set function that takes in an input _data
     * @dev this function updates the value of storedData - since storage is updated, this changes state of blockchain
     * @dev everytime state is changed, a consensus needs to be arrived on chain - this consumes gas of user
     * @dev function returns a bool value
     */
    function setStoredData(uint _data) public returns(bool){

        storedData = _data;
        return true;
    } 
}

