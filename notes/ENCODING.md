# ENCODING/DECODING

In this section, I list the advanced topics of solidity. Following topics are discussed

-   low level calls using data in bytecodes
-   How do we encode and decode data
-   function signature encoding
-   Opcodes & gas usage
-   How does compiler work

## Bytecode

-   When we send a transaction, it is compiled down to its bytecode & this bytecode is sent in "data" object
-   bytecode represents low level code that is understood by EVM compiler
-   This is essentially a bunch of opcodes stacked together -> compiler breakdown this bytecode into a series of instructions, each instruction specific to its corresponding OPCODE (eg. push/add/subtract/append etc)

-   We can go through list of opcodes at [EVM codes](https://www.evm.codes/) or use this [github repo](https://github.com/crytic/evm-opcodes)

-   Reading these opcodes is primarily the job of EVM
-   **Any language that can compile bytecode using these opcodes is said to be EVM compatible**
-   We have lower level encoding/decoding functions such as

    -   `abi.encode`
    -   `abi.encodePacked`
    -   `abi.decode`

-   Additionally, we can typecast `bytes` to `string`
-   We convert function signature to bytecode using `abi.encode` and then we proceed to pass this bytes data in `call` function `data`. We get back the output also as bytes data

Refer to [16-Encoding.sol](../contracts/16-Encoding.sol) for examples on this

## Using call function

-   Call function takes in bytes code & returns a boolean (if success) and output data (bytes)

-   Example below shows how we use bytecode data in call functions

```
    bytes memory data = abi.encode(keccak256(transfer(address sender, address receiver, uint256 amount)))
    (bool success, bytes memory output) = <Contract>.call{value: ethers.utils.parseEther("1")}(data)
```

-   Note that data takes bytes data obtains by encoding function signature.

-   When we don't pass any data in `call` function, we can execute simple transfers as below

```
    (bool success, ) = <Contract>.call{value: ethers.utils.parseEther("1")}("")
```

-   We also looked at 2 variants of `call` - `staticCall` and `delegateCall`. Along with `call`, these 2 are also low level functions

-   We learn how to call bytes data using `callTransferFunctionDirectly` and `callTransferFunctionDirectlyWithSignature`. First function, we manually generate bytes4 function selector (name of function), second function we use solidity function `abi.encodeWithSignature()` to get the function selector

Refer to [16-Encoding.sol](../contracts/16-Encoding.sol) for examples on this

## Calling functions of a contract without ABI

-   We can call functions of an external contract without even accessing the ABI
-   Same concept as above, this time, we just need the address where the contract code resides
-   This basically means that we can change state of an address from another address without accessing its ABI

Refer to [17-CallFunctionsWithoutContract.sol](../contracts/17-CallFunctionsWithoutContract.sol) for an example
