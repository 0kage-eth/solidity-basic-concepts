# INHERITANCE

## BASICS

-   Solidity supports multiple inheritance including polymorphism
-   Polymorphism means function call (internal or external) always executes function of same name (and parameters) in the most derived contract in inheritance hierarchy
-   Has to be explicitly enabled in each function using `virtual` and `override` keywords
-   Can call function one level above by `super.functionName()`
-   For a call function of a specific contract we can do `ContractName.functionName()`
-   When a contract inherits from other contracts, only single contract is created on blockchain, and code from all base contracts is compiled into the derived contract
-   This means all internal calls of functions in base contracts use internal function calls (`super.f(...)` uses JUMP and not message call)
-   functions without implementation have to be marked `virtual`
-   If a contract inherits from multiple contracts, most derived base contracts that define same function must be specified explicitly after `override` keyword - specify all base contracts that define same function and have not yet been overridden by another base contract

    ```
        contract Base1{
            function pow() virtual public{}
        }

        contract Base2{
            function pow() virtual public{}
        }

        contract Base3 is Base1, Base2{
            function pow() override(Base1, Base2){

            }
        }

    ```

For more information, refer to [11-Inheritance.sol](../contracts/11-Inheritance.sol)
