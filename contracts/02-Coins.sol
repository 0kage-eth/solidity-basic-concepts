// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
 * @title Simple Coin issuance contract
 * @author 0Kage
 * @notice Contract where owner can mint new coins and users can send coins
 * @dev In this contract we delve deeper into variables and other contract components
*/
contract Coins{
    
    /**
     * @notice owner of the contract who can mint coins 
     * @dev address type is a 160 bit value - does not allow arithmetic operations
     * @dev address is used for storing public addresses
     * @dev we need to make sure only minter can create coins
     * @dev i_minter notation means that it is a immutable storage variable
     * @dev immutable variable can only be set once in the constructor & never changed
     * @dev if variable has to be accessed from other address, we can make it public/external
     *  */ 
    address immutable i_minter;

    /**
     * @notice mapping is used to create a kind of key value pair. 
     * @dev mapping can be seen as a hash table
     * @dev maps every key that exists from start with a default value - zero
     * @dev this is why we don't need to worry whether an addrress exists in a mapping ot not
     */
    mapping(address => uint) public s_balances;

    /**
     * @notice events - events are emitted when certain functions or state changes are triggered
     * @dev we define an event with name and its args
     * @dev web front-end can listen to these events without much cost
     * @dev this is why we don't need to worry whether an addrress exists in a mapping ot not
     * @dev In the current event, as soon as event is emitted, listener will receive a trigger with values of sender, receiver and amount
     */
    event Sent(address sender, address receiver, uint amount);

    /**
     * @notice Constructor code is only run when contract is created
     * @notice This code exists in storage of an address when 'to' address is null
     * @dev note that msg.sender and msg.value are global variables
     * @dev msg.sender gives address from where current call came from
     * @dev msg.value gives amount of eth transferred in wei termss
     * @dev we dont need to pass these global variables
     */
    constructor() {
        i_minter = msg.sender;
    }

        /**
     * @notice error is used to define custom errors
     * @notice error can also pass args - will help in better UX
     * @dev if a particular condition fails, we revert with this error
     * @dev purpose of defining these errors is to give more information to dapps/front-end users
     * @dev error name convenstion is <Contract>__<ErrorName>(args) -> first part is name of Contract, second part is actual error name
     */

    error Coins__InsufficientBalance(uint requested, uint available);


        /**
     * @notice functions are where logic is executed
     * @notice mint function mints a specific amount of token 
     * @dev functions can be public/private/internal or external
     * @dev functions can return a value, can use modifiers and can be read only (view/pure)
     */ 

    function mint(address receiver, uint amount) public {
        
        // require reverts all changes if sender is not the original minter
        // only contract deployer can mint new coins
        require(msg.sender == i_minter);

        //increase receiver balance by amount - process of minting new coins
        // at some point, this can create a 'overflow' error when amounts exceed maximum value for a uint type
        // at point where s_balances[receiver] + amoount > 2**256 -1, txn reverts because of overflow error
        s_balances[receiver] += amount;
    }

        /**
     * @notice send function sends tokens to receiver
     * @dev  checks if it has enough tokens to send 
     * @dev if no, reverts to Error__Insudfficient balance
     */ 
    function send(address receiver, uint amount) public {
        if(amount < s_balances[msg.sender]){
            // we revert to an error 
            // notice that we are also passing in args for requested/available amount
            // revert unconditionally aborts and reverts all changes made to state - similar to require()
            revert Coins__InsufficientBalance({requested: amount, available: s_balances[msg.sender]});            
        }
        s_balances[msg.sender] -= amount;
        s_balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
 
    }

    // Getter functions
     
     /**
     * @notice functions with tag 'view' don't change state of blockchain
     * @notice these functions don't consume gas
     * @dev external functions can only be accessed from outside the contract
     */ 
    function getBalance(address account) external view returns(uint) {
        return s_balances[account];
    }
}