// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;



/**
 * @title Variables explorer
 * @author 0Kage
 * @notice Deep dive into variables, enums, structs, modifiers, inheritance
*/

contract VariablesExplorer {
    
    /**
     * @dev Lets look at addresses first
     * @dev I use s_* to denote variable sits in storage
     * @dev 'address' type holds 20 byte value - standard size of Ethereum address
     * @dev 'address payable' type is same as address but with 'transfer' and 'send' functions
     * @dev You can only send eth to an address marked as 'address payable'
     * @dev you are not supposed to send eth to a plain address as it might be a smart contract not built to receive eth
     * @dev In solidity, address is of data type byte[] - it is a sequence of bytes
     * @dev solidity has 2 bytes types - fixed size byte arrays and variable sized byte arrays
     * @dev bytes represents an array of bytes. Its a shorthand for byte[]
     */

    address public s_owner;  // initial value would be 0x0000000000000000000000000000000000000000

    address payable public s_receiver; // payable tag designates that this address can receive payments

    /**
     * @dev implicit conversion of an address payable -> address  is allowed
     * @dev address to address payable, however must be explicit
     * @dev this is to avoic accidental mistakes of sending eth to a simple address
     * @dev following line forces a type conversion explicitly
     */

    s_receiver = payable(s_owner)



    /**
     * @dev address type comes with 2 members - balance & transfer
     * @dev balance gives balance in the current address 
     * @dev transfer allows us to make a transfer of eth (in wei) to another payable address
     */

    uint256 private _senderBalance = s_owner.balance;

    /**
     * @dev to get balance of current contract, we can use this keywork
     */
    uint256 private _currentContractBalance = address(this).balance;


    /**
     * @dev transfer eth to a payable address
     * @dev receiver address should have a fallback() implemented - or transfer will result in an error
     * @dev there is a gas limit of 2300 gas which is enough to complete transfer (hardcoded to prevent re-entrancy??)
     * @dev in this case, s_receiver address receives 10 wei from this contract address
     * @dev this address -> s_receiver for 10 wei
     * @dev if 'this' address does not have wei, transfer function fails & eth transfer rejected by receiving accoun
     * @dev transfer function reverts in that case with an exception
     */
     s_receiver.transfer(10)


    /**
     * @dev we can use a send method to transfer 
     * @dev unlike transfer, send does not throw an exception but send returns false
     * @dev also has hardcoded value of 2300 gas
     * @dev always check value of send - and proceed only if true
     * @dev recommended to use transfer than send
     */
     s_receiver.send(10)

    /**
     * @dev a better way to transfer is by using call (recommended way)
     * @dev call takes a 'bytes memory' parameter and returns success condition as 'bool' and returned data ('bytes memory')
     * @dev empty argument triggers a fallback function on receiving address as below
     * @dev in below example, fallback gets triggered and send tells us whether transfer went through or not
     */

    (bool send, "") = s_receiver.call{value: msg.value}("");
    require(send, "Transfer failed");

    /**
     * @dev we can also pass bytes memory in the call to send gas to that contract & transfer value to the contract
     */
    bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
    (bool send2, "") = s_receiver.call{value: msg.value, gas:2300}( payload);
    require(send2, "Execution failed");


    /**
     * @dev lets look at integer types
     * @dev uint by default maps to uint256, 256 bit integer
     * @dev u in uint stands for unsigned integer - obviously, this means negative values are not allowed with uint
     */

    uint immutable i_counter;

    /**
     * @dev uint256 is a 256 bit integer, max value is 2**256 -1
     * @dev manually describing size is recommended for code clarity
     */
    uint256 private s_minGasFee;

    /**
     * @dev uint8 max acceptable value is 2**8 -1 = 255
     */ 
    uint8 private s_uint8Number;

    /**
     * @dev uint16 max acceptable value is 2**16 -1 = 65535
     */ 
    uint16 private s_uint16Number;

    /**
     * @dev uint32 max acceptable value is 2**32 -1
     */ 
    uint32 private s_uint32Number;


    /** NORMAL INTEGERS
     * @dev Normal integers can store positive and negative values
     * @dev Max values a normal integer can store is less than uint by a factor of 2
     * @dev int32 number can range from -2**31 to 2**31-1
     * @dev int256 number can range from -2**255 to 2**255-1
     */

    int16 private s_int16Number = -2**7; // note that for a uint16, max is 2**8-1
    int32 private s_int32Number = -2**31;
    int256 private s_int256Number = -2**255;

    int256 private s_minInt = type(int256).min;
    int256 private s_maxInt = type(int256).max;

     /** BOOLEAN
     * @dev boolean type - true/false. defaults to false
     */ 
    bool private s_flag = false; 

    /** MAPPING 
     * @dev  mapping is a hash table with key-value pairs
     * @dev mapping is a reference type -> we need to explicitly provide data area where data is stored
     * @dev data can be stored in storage, memory or calldata
    */
    mapping (address => uint) public s_balances;

    /** STRING
     * @dev string is essentially a dynamic sized bytes array
     * @dev in below example, 0Kage is string literal and s_name is string variable
     */
    string internal s_name = "0Kage";

    /**
     * @dev preferred way is to use bytes
     * @dev bytes cost less gas than string
     */
    bytes32 internal s_name_bytes = "0Kage";

    /** ARRAY
     * @dev array can be defined by []
     * @dev array is a reference type and we need to explicitly provide location -> memory, storage or calldata
     */
    uint256[] public s_numbers;

    /** ENUMS
     * @dev Enums create a user-defined type in solidity
     * @dev enums require atleast one member. default value is first member
     * @dev enums are explicity convertible to and from integer
     * @dev max enums we can have is 256 (uint8 limittation)
     */

    enum Actions{walk, ride, row, talk, sit, stand};
    Actions private myAction;

    function Row() public {
        myAction = Actions.row;
    }

    uint8 _smallestEnum = type(Actions).min;
    uint8 _largestEnuk = type(Actions).max;
    
    /**
     * @dev enums are not part of ABI, signature of getAction
     * @dev will automatically change to "function getAction() returns (uint8)"
     * @dev whenever signature is generated outside of solidity, enum resolves to uint8
     */
    function getAction() public view returns(Actions){
        return myAction;
    }

    /** STRUCT 
     * @dev Struct is used to combine different data types
     * @dev Struct is a reference type
    */
    struct Pizza {
        string name;
        uint256 quantity;
    }

    Pizza[] public s_items;
    

    /** CONSTRUCTOR
     * @dev We can pass variables at the time of deployment to initialize values
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