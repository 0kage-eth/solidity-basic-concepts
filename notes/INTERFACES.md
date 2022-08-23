# ABSTRACT CONTRACTS AND INTERFACES

## Abstract Contracts

-   Contracts must be marked abstract when atleast one of their functions is not implemented or when they do not provide arguments for all of their base contract constructors

-   Even if not above, contract can still be marked abstract when you don't intend to recreate the full contract (eg. interfaces, explained below)

-   Abstract contracts are similar to interfaces but interface is more limited in what it can declare (more on this below..)

-   Abstract contract is declared using `abstract` keyword

-   Abstract contracts cannot be instantiated directly.

-   If a contract inherits from an abstract contract but does not implement a function (not defined in abstract contract) by overriding it - then this contract should also be marked `abstract`

-   Abstract contracts decouple definition of contract from its implementation providing better extensibility

Refer examples in [12-Abstract.sol](../contracts/12-Abstract.sol)

## Interfaces

-   Interfaces are similar to abstract functions but **they cannot have any function implemented**

-   There are following restrictions while defining interface

    -   cannot inherit from other contracts but can inherit from other interfaces
    -   all functions must be declared `external` in interface , even if they are `public` in contract
    -   cannot declare a constructor
    -   cannot declare state variables
    -   cannot declare modifiers

-   Interfaces are limited by what contract ABI can represent, conversion between ABI and interface should be possible without any information loss

-   Contracts can inherit interfaces as they inherit other contracts

-   **all functions defined in interfaces are implicitly virtual. And we don't need `override` keyword to override functionality - just use as is**

-   Intefaces help us use function logic in other contracts without worrying about its implementation

-   Good practice to name interfaces starting with `I`

For an example, refer to [13-Interfaces.sol](../contracts//13-Interfaces.sol)
