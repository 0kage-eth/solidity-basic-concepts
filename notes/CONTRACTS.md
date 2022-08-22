# CONTRACTS

## CREATION

-   Contracts can be created "from outside" via Ethereum Transactions or from within Solidity contracts
-   We can use web3.js or ethers.js library to create contracts programatically. They are Javascript APIs
-   When contract is created `constructor` function is executed once (`constructor` is a special function that uses that keyword)
-   Once constructor is executed, final code of contract is stored on blockchain
-   This deployed code contains all public and external functions. does not include constructor and internal functions
-   If contract wants to create another contract, code of the created contract has to be known to creator upfront

## FUNCTION VISIBILITY

-   `public` functions are part of contract inteface and can either be called internally or via message calls

-   `internal` functions can only be accessed from current contract or contracts deriving from it. Cannot be accessed externally

-   `external` functions are part of contract interface - they can be called from other contracts or via transactions. External function `f` cannot be called internally (`f()` wont work but `this.f()` will)

-   `private` functions are like internal functions but not visible in derived contracts

## GETTER FUNCTIONS

-   compiler automatically creates getter functions for all public state variables
-   Getter function has external visibility - if a public variable is accessed internally, it evaluates to a state variable (eg. `data`). if it is access externally (using `this` it evaluates to a function (eg. `this.data()`))
-   If we have a public state variable of `array` type, getter function only retrieves single elements of array- this is to save on gas costs

## MODIFIERS

-   Modifiers can be used to change behavior of functions in a declarative way
-   We can use modifier to automatically check for condition before executing a function
-   Modifiers are inheritable properties of contracts and may be overridern by derived contracts, but only if they are marked `virtual`

-   `_` symbol can appear multiple times within modifier. Each occurence is replaced by function body

## CONSTANT & IMMUTABLE

-   State variables can be declared as `constant` or `immutable`
-   Both cases, variables cannot be modified after contract has been constructed
-   for `constant` variables, value has to be fixed at compile time
-   for `immutable`, variable value has to be fixed at constructor creation
-   Note that compiler does not reserve a storage slot for these variabels and every occurence is replaced by respective value
-   gas costs are much lower than state variables
-   Immutables assigned at declaration are only considered initialized once constructor of contract is executing

## FUNCTIONS

-   Functions can be defined outside a contract - but still are executed in context of contract
-   main difference from functions defined inside contract - outside functions do not have access to variable `this` - storage variables and functions not in their scope
-   functions with `view` do not modify state - at a low level, `view` functions use `STATICCALL`
-   for library `view` functions, at a low level, `view` functions use `DELEGATECALL`
-   Functions can be declared `pure` if they don't read or modify state
-   Should be possible to evaluate a `pure` function at compile time given only its inputs and `msg.data` but without any knowledge of current blockchain state

**Special Functions**

-   `receive()` and `fallback` are special functions supported by solidity
-   Both of them don't need a `function` keyword

_receive()_

-   `receive()` function cannot have arguments, cannot return anything and must have `external` and `payable` keyword
-   `receive` gets called when contract is called with empty calldata. This is the function that gets executed when `.send()` or `.transfer()` is used by a sender
-   If no such function exists and a user uses `.send()` or `transfer()` functions, then a payable `fallback` function gets executed if it exists. If event that doesn't exist, then exception is thrown when we try to send ether to contract
-   `receive()` can be virtual, override and can have modifiers
-   `receive()` function can only use a amax of 2300 gas for performing operations. Nothing complex can be done inside this - except for logging
-   **Note that a contract without `receive` can still receive ether as a recepient of a _coinbase transaction_ (miner block reward) or a destination of `selfdestruct`**. In this case
    -   contract cannot react to Eth transfers and cannot reject them
    -   address(this).balance may not match the manual acccounting we do inside contract (because balance is updated w/o state being reverted)\*\*

_fallback()_

-   fallback can be declared using `fallback (bytes calldata input) external [payable] returns (bytes memory output)`
-   fallback function can be virtual, can override or have modifiers
-   gets triggered when a function call on a contract has no matching signatures or if `receive` is not defined and no data was supplied (in this case however, it should be a `payable` function)
-   `input` will contain full data sent to contract (`msg.data`) and can return data in `output`
-   Same as its `receive` counterpart, `fallback` can only use 2300 gas

For more on fallabacks and receive, refer to [10-FallbackAndReceive.sol](../contracts/10-FallbackAndReceive.sol)
