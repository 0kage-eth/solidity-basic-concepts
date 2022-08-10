// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/**
 * This file, I explore solidity variables & data types
 * Storage variables, memory variables and global variables 
 * Public, Private, Immutable variables
 */

contract VariablesExplorer {

    /** ADDRESSES */
    // I use s_* to denote variable sits in storage
    // Addresses hold 20 byte value
    // payable tag is used for addresses that receive ether
    // In solidity, address is of data type byte - it is a sequence of bytes
    // solidity has 2 bytes types - fixed size byte arrays and variable sized byte arrays
    // bytes represents an array of bytes. Its a shorthand for byte[]
    //
    address public s_owner;  // initial value would be 0x0000000000000000000000000000000000000000


    // PUBLIC/PRIVATE/INTERNAL/EXTERNAL
    // public variable is available to external contracts & inside contract
    // external variable is only available to external contract calls (not internal)
    // private is not available for any external contract calls
    // internal is only available to contracts that inherit from this contract - not external contract calls
    // note that unassigned variables have defaults of 0 (uint256) and 0x0000 for address
    address payable public s_receiver; // payable tag designates that this address can receive payments



    /**
     * UNSIGNED INTEGERS
     */
    // uint by default maps to uint256, 256 bit integer
    //u in uint stands for unsigned integer - obviously, this means negative values are not allowed with uint
    uint immutable i_counter;

    //uint256 is a 256 bit integer, max value is 2**256 -1
    // manually defining size is prescribed for code clarity
    uint256 private s_minGasFee;

    //uint8 max acceptable value is 2**8 -1 = 255
    uint8 private s_uint8Number;

    //uint16 max acceptable value is 2**16 -1 = 65535
    uint16 private s_uint16Number;

    //uint32 max acceptable value is 2**32 -1
    uint32 private s_uint32Number;


    /** NORMAL INTEGERS
     * Normal integers can store positive and negative values
     * Max values a normal integer can store is less than uint by a factor of 2
     * int32 number can range from -2**31 to 2**31-1
     * int256 number can range from -2**255 to 2**255-1
     */

    int16 private s_int16Number = -2**7; // note that for a uint16, max is 2**8-1
    int32 private s_int32Number = -2**31;
    int256 private s_int256Number = -2**255;

    int256 private s_minInt = type(int256).min;
    int256 private s_maxInt = type(int256).max;



    /** BOOLEAN */
    bool private s_flag = false; // even if we don't ionitialize, boolean initializes to false

    /** MAPPING */
    // mapping is a hash table with key-value pairs
    mapping (address => uint) public s_balances;

    /** STRING
     * string is essentially an array
     */
    string internal s_name;

    /** ARRAY
     * array can be defined by []
     */
    uint256[] public s_numbers;

    
    /** STRUCT */
    struct Pizza {
        string name;
        uint256 quantity;
    }

    Pizza[] public s_items;
    

    /** CONSTRUCTOR
     * We can pass variables at the time of deployment to initialize values
     */
    constructor(uint _ctr, string memory _name, address _receiver) payable {
        // immutable variables can be initialized only once
        i_counter =_ctr;
        s_receiver = payable(_receiver);
        s_name = _name;

    }

    /** FUNCTION */
    function populateNumbers(uint256[] memory _inputs) public returns(bool){
        /** array can also be defined in memory
         * consumes less gas but state is not persistent
         * only lasts until txn is active
         */
        uint256[] memory m_numbersMemory;

        for(uint256 i =0; i<_inputs.length; i++){
            s_numbers.push(_inputs[i]); // This is persistent - state update lasts beyond msg call
            // m_numbersMemory is lost the moment txn is completed
            // every txn has a new memory allocation - same is not the case with storage
            // memory is cheaper than storage
            m_numbersMemory[i] = _inputs[i]; // note that we didn't push - just put it in the corresponding memory location
        }


        return true;
    }

    /** PLAYING WITH STRUCT */
    function populatePizzas(string memory _name, uint256 _quantity) public {
        // note that we are telling EVM to store _food in memory
        // s_items is persistent because it will be stored in storage
        Pizza memory _food =  Pizza({name: _name, quantity: _quantity });
        s_items.push(_food);
    }



}