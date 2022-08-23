# LIBRARIES

-   Libraries are similar to contracts but with reusability
-   Libraries are deployed on-chain & their code can be accessed by any contract using `DELEGATECALL`
-   Libraries help in composability/re-usability and keep codebase concise

-   `DELEGATECALL` means that library code gets executed in the context of the calling contract (storage, address and stack are of calling contract)

-   As library is isolated piece of code, storage variables of calling contract have to be passed as explicit args

-   Library functions can be called directly (without using `DELEGATECALL`) if they are pure/view functions that don't change state

-   Libraries are inherently stateless and we cannot destroy library once created. They cannot hold state variables and cannot hold ether

-   Libraries can be seen as inherent base contracts of the contracts that use them - will not be visible in inheritance hierarchy

-   Calls to libraries look just like calls to functions in base contracts

-   **Calling a public library function `L.f()` results in a external call using `DelegateCall`. Calling a internal function of an external contract `A.f()` results in a internal call**

-   We can do `using L for *` to attach library functions to all types

-   Else `using L for T` to attach library functions to type T. This is active only within current scope, ie contract or function it is defined.

Go through examples [14-Library.sol](../contracts/14-Library.sol) and [15-Library.sol](../contracts/15-Library.sol)
