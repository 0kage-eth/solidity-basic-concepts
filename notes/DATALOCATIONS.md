# DATA LOCATIONS

## SUMMARY

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
