// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// @title Simple Coin issuance contract
/// @author Sushant Reddy Cheruku
/// @notice Contract where owner can mint new coins and users can send coins
/// @dev Explain to a developer any extra details
contract Coins{
    
    // owner of the contract who can mint coins
    // address type is a 160 bit value - does not allow arithmetic operations
    // address is used for storing public addresses
    // we need to make sure only minter can create coins
    // i_minter notation means that it is a store variable
    // immutable variable can only be set in the constructore
    // if variable has to be accessed from other address, we can make it public
    address immutable i_minter;

    // mapping is used to create a kind of key value pair
    // cann be seen as hash table
    // maps every key that exists from start with a default value - zero
    // this is why we don't need to worry whether an addrress exists in a mapping ot not
    mapping(address => uint) public s_balances;

    // events - events are emitted when certain methods are trigger
    // we define an event with name and its args
    // Ethereum clients can listen to these events without much cost
    // As soon as event is emitted, listener will receive a trigger with values of sender, receiver and amount
    event Sent(address sender, address receiver, uint amount);

    // Constructor code is only run when contract is created
    // note that msg.sender and msg.value are global variables
    // msg.sender gives address from where current call came from
    // msg.value gives amount of eth transferred in wei termss
    // we dont need to pass these global variables
    constructor() {
        i_minter = msg.sender;
    }

    //error is used to define custom errors
    // error can also pass args - will help in better UX
    // if condition fails, we revert with this error
    // purpose of defining these errors is to give more information to users
    error Coins__InsufficientBalance(uint requested, uint available);

    function mint(address receiver, uint amount) public {
        
        // require reverts all changes if sender is not the original minter
        // only contract deployer can mint new coins
        require(msg.sender == i_minter);

        //increase receiver balance by amount - process of minting new coins
        // at some point, this can create a 'overflow' error when amounts exceed maximum value for a uint type
        // at point where s_balances[receiver] + amoount > 2**256 -1, txn reverts because of overflow error
        s_balances[receiver] += amount;
    }

    // send function sends tokens to receiver
    // checks if it has enough tokens to send
    // if no, reverts to Error__Insudfficient balance
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
    // external type of functions can only be called from outside contracts
    function getBalance(address account) external view returns(uint) {
        return s_balances[account];
    }



}