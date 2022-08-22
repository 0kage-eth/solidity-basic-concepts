# SOLIDITY BASICS

Listed some key topics here worth reading up on Solidity

## MEMORY LOCATIONS

There are 3 places where data can be stored

-   `Storage` - persistent across function calls. Stored on blockchain
-   `Memory` - non-persistent. Fresh instance of memory allocated on each function call. Doesn't last beyond function call
-   `Call data` - non-modifiable, non-persistent area where function arguments are stored. Behaves mostly like Memory

---

## ASSIGNMENT

-   Assignment between `storage` and `memory`(or `calldata`) always creates an independent copy
-   Assignment between `memory` and `memory` creates a reference. Change to one variable changes value of all variables pointing to same location
-   Assignment from `storage` to local `storage` also only assigns a reference
-   All other assignments to `storage` create a copy

Refer to [04-DataLocation.sol](./DATALOCATIONS.md) for an example

## ARRAYS

-   Arrays of fixed size (k) are defined as T[k] and dynamic size are defined as T[]
-   Variables of `bytes` and `string` are special arrays
-   `bytes` type is similar to `bytes1[]`. `string` is equal to `bytes` but does not allow length or index access
-   Memory arrays with dynamic length can be created using `new` operator
-   **As opposed to storage arrays, it is not possible to resize memory arrays**
-   **For arrays in memory, .push() functions are not available**
-   When handling memory arrays, always use fixed size arrays
-   Array has functions push(x), pop(), length
-   `x[start:end]` gives array elements from `x[start]` to `x[end-1]`

Refer to [05-MemoryArrays.sol](../contracts/05-MemoryArrays.sol) and [06-WorkingWithArrays.sol](../contracts/06-WorkingWithArrays.sol) for more on arrays

## MAPPING

-   Mapping is declared using `mapping(keyType => ValueType) variableName`. Key type can be any built in type, bytes, string, contract or enum type. **User defined types such as mappings/structs or array types are not allowed** Value type can be any type including mapping, struct or arrays
-   Mapping can be thought of as `hash tables` - virtually initialized such that every possible key exists and mapped to a value whose byte representation is all 0, default value
-   Key data is not stored in mapping - only its `keccak256` hash is used to look up value
-   **Mappings can only have data location of `storage` & are allowed for state variables, as storage reference types in functions or parameters of library functions**
-   **Cannot be used as parameters or return parameters of contract function that are publicly visible (since such parameters are stored in memory)**
-   **You cannot iterate over mappings, ie you cannot enumerate their keys**

Refer to [07-MappingsERC20.sol](../contracts/07-MappingsERC20.sol) for a simplified ERC20 example that extensively uses Mappings

## GLOBAL VARIABLES AND UNITS

-   1 eth = 10^9 gwei = 10^18 wei
-   Special variables and functions always exist in global namespace & mainly used to provide info on blockchain
-   Some of the important ones are

    -   `block.timestamp (uint)`: current block timestamp as seconds since unix epoch
    -   `block.gaslimit(uint)`: current block gas limit
    -   `block.number(uint)`: current block number
    -   `blockhash(uint blockNumber) returns (bytes32)`: returns blockhash
    -   `msg.data (bytes calldata)`: complete call data
    -   `msg.sender(address)`: sender of current message call
    -   `msg.value(uint)`: number of wei sent with the message
    -   `msg.sig(bytes4)`: first four bytes of call data (function identifier)
    -   `tx.gasprice(uint)`: gas price of transaction (includes all message calls)
    -   `tx.origin (address)`: sender of transaction (full call chain)
    -   `gasLeft() returns (uint256)`: remaining gas

-   Assert and Require functions are for error handling
-   `assert(bool condition)` causes panic error and thus state change reversion if condition is not met - to be used for internal errors
-   `require(bool condition, string memory message)` reverts if condition is not met - to be used for errors in internal and external components. Can provide a custom mesaage
-   `revert(string memory reason)` abort execution and revert state changes - provide a reason for same
-   `keccak256(bytes memory) returns bytes32` - compute keccak256 hash of input
-   `sha256(bytes memory) returns bytes32` - compute sha256 hash of input

-   Here are some useful members for `address` type

    -   `<address>.balance(uint256)`: balance of address in wei
    -   `<address>.code(bytes memory)`: code of address (can be empty)
    -   `<address>.codehash(bytes32)` : codehash of the address
    -   `<address payable>.transfer(uint256 amount)`: send given amount of Wei to an address, reverts on failure, forwards 2300 gas stipend, not adjustable
    -   `<address payable>.send(uint256 amount) returns(bool)`: sends given amount of Wei to an address, does not revert on failure, returns false, forwards 2300 gas stipend, not adjustable
    -   `<address>.call(bytes memory) returns (bool, bytes memory)`: issue low level CALL with given payload, returns success condition and returns data, forwards all adjustable gas, adjustable
    -   `<address>.delegateCall(bytes memory) returns (bool, bytes memory)`: issues low-level DELEGATECALL with given payload, returns success condition and returns data, forwards all available gas, adjustable
    -   `<address>.staticCall(bytes memory) returns (bool, bytes memory)` - issues low level STATICCALL with given payload, returns success and returns data. forwards all available gas, adjustable

    **Note that low level calls happen at address level instead of contract level**
    **EVM considers a call to non-existent contract to always succeed. Low level calls don't check if the function code exists - use them with care**

-   Here are some `contract` related members:

    -   `this()` explicitly convertible to `address`
    -   `selfdestruct(address payable recepient)` destroys current contract sending funds to given recepient address and end execution. When self destruct executes,
        -   receiving contract's `receive` (callback) function **does not** get executed
        -   contract is only destroyed at end of transaction & any `revert` can **undo the destruction**

-   `type(X)` can be used to retrieve information about type `X`. Following properties are available at contract level C

    -   `type(C).name` gives name of contract
    -   `type(C).creationCode` memory byte array that contains creation code of contract
    -   `type(C).runtimeCode` gives runtime bytecode of contract
    -   for integer type, we can use `type(T).min` and `type(T).max`

## FUNCTION CALLS

-   Function calls can be internal, external, private or public
-   _Internal calls_

    -   function calls can be directly called internally
    -   This has the effect that internal memory is not cleared
    -   only functions of same contract can be called internally
    -   can be called from contracts that inherit as well
    -   Even recursive calls allowed but avoid it inorder to not exceed 1024 stack limit

-   _External calls_

    -   Functions of other contracts have to be called externally
    -   for an external call, all function arguments have to be copied to memory
    -   function call from one contract to another is not a transaction - it is a message call
    -   Note that you can send amount of wei & gas to any function call by adding `{value: 200000, gas: 10000}`. This is not a best practice specially for gas - gas prices for opcodes can change

-   _Creating new contracts within function_

    -   We can create new contracts from within a function
    -   Contract code of created contract should be known upfront for this to work
    -   Note that we can also fund contract with eth

    Refer to [08-CreateNewContract.sol](../contracts/08-CreateNewContract.sol) for an example

## EXPRESSIONS

-   Overchecked and underchecked variables - prior to 0.8.0, operations would always wrap in case of over or underflow leading to widespread use of libraries that use unchecked libraries
-   Post 0.8.0, over/undeflow reverts, making use of libraries unnecessary
-   To prevent reverting & enable wrapping, `unchecked` block can be used everywhere inside the block
-   `unchecked` block cannot be nested

## ERROR HANDLING

-   Solidity uses state reverting exceptions to handle errors
-   Exception undoes all changes made to state in current call(and all its sub calls) and flags an error to caller
-   When exceptions happen in sub-call, they bubble up the stack
-   Only exception for above is low-level calls on addresses (send/call/staticall, delegatecall) - in this case, we get a `false` in case of exception instead of bubbling up
-   Exceptions can contain error data that is passed back to caller in the form of error instances
-   In following situations, an error string of type `Error(string)` is returned

    -   calling `require(x)` when `x` evaluates to false
    -   use `revert()` or `revert(description)`
    -   perform an external function call targeting a contract that contains no code
    -   contract receives ether via a public function without `payable`
    -   contract receives eth via public getter function

-   for following cases, error data from external call(if provided) is forwarded
    -   `.transfer()` fails
    -   if a function is called via message call does not finish properly (runs out of gas, exception, no function found in contract) - exceptions for these are low level calls that dont revert an error
    -   create a contract with `new` keyword but contract does not finish properly

**assert()**

-   `assert` can be used to check conditions and throw an exception if condition is not met
-   `assert` function creates an error of type `Panic(uint256)`
-   **Assert should only be used to check internal errors and invariants**
-   Properly functioning code should never trigger panics, not even on externally invalid input
-   Panic error should be caused in few cases such as
    -   division by zero
    -   unchecked block - operation leading to underflow or overflow
    -   convert a value too big or negative to enum
    -   access storage byte that is incorrectly encoded
    -   call `.pop()` on empty array
    -   access out of bounds or negative index in array
    -   allocate too much memory or array too large

**require(error)**

-   `require` function creates an error without data or error of type `Error(string)`
-   should be used to execute valid conditions that cannot be detected until execution
-   To revert with custom errors, we cannot use `require`.
-   Use `if(!condition) revert CustomError();` instead
-   You can provide a optional message string with `require`

**revert(error)**

-   `revert CustomError(args1, args2)` creates a custom error where we can pass parameters
-   We can also use `revert(description)`

**Error behavior**

-   Solidity performs a revert operation internally.
-   Causes EVM to revert all changes made to state.
-   Reason for reverting is because there is no safe way to continue execution
-   safest way is to revert all changes in transaction (across multiple message calls) and make whole transaction without effect
-   Caller can catch errors using try/catch but changes will be reverted nevertheless
-   Failure can be detected by try/catch loop. `try` keyword has to be followed with a function call or contract creation

---
