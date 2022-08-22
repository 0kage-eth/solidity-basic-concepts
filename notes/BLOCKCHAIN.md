# BLOCKCHAIN BASICS

## WHAT IS A BLOCKCHAIN?

-   Blockchain is a globally shared, transactional database
-   Everyone can read from the database without permission. Everyone can sign their txn, spend some fees and write to the database without permission
-   Cryptographic signing provides a guarantee that only certain users can modify certain parts of database

---

## WHAT IS A BLOCK?

-   Transactions are bundled together, executed and distributed to all other participants of network. Bundling of txns is called a 'block'
-   Blocks form a linear sequence of time - and this creates a chain called the blockchain
-   Ordering of blocks is done by special participants called miners who get compensated by users
-   During ordering, blocks at the tip may be reverted. This happens when 2 blocks are mined at exact time & we have to wait for next block to achieve finality.
-   Farther the blocks from tip, less likely that they get reverted.

---

## EVM

-   EVM is a runtime environment for smart contracts
-   It is completely isolated, code cannot access files on system or any other external data source/network
-   Smart contracts have limited access to other contracts (except libraries)

### Accounts

-   2 types of accounts - Externally owned accounts (EOA) and Contract accounts (CA)
-   EOA can be accessed by private keys. Address is determined by public key
-   CA is determined by creator address and number of transactions sent by account (called nonce)
-   CA stores code while EOA does not have code. EVM treats both accounts equally
-   Each account has a persistent key-value store mapping 256-bit word to 256-bit word called 'Storage'
-   Each account has a balance in wei (10\*\*-18 eth)

### Transactions

-   Transaction is a message sent from one account to other - can contain data (referred to as paload) and eth
-   If target account contains code, code gets executed with data in payload acting as inputs
-   If target account is not set, then transaction creates a new contract. In this specific case, payload of txn is considered to be EVM code & executed. Output of this code is permanently stored as code in the new contract
-   In order to create a new txn, we don't send actual code but a code that creates this actual code
-   **While a contract is being created, its code is still empty. Because of that, you should not call back into the contract under construction until its constructor has finished executing**

### Gas

-   Originator of transaction has to pay some fees in ETH to create a contract or change state of blockchain
-   As EVM executes txn, gas gets consumed for every operation
-   If EVM finds gas is exhausted, all state changes in current call state till that point are reverted. Consumed gas is not returned
-   Gas mechanism forces participants to play fair, and try to economically use network - bots with infinite recursive loops can never paralyze the network
-   Gas also acts as an incentive for miners to mine block & agree on a consensus
-   Gas price is a value set by originator. gas price \* gas is charged to the originator. If some gas is left, it is refunded to originator
-   Too low a gas price & miners can choose to ignore txn - so optimal gas fee is a function of supply & demand for block space

### Storage, Memory & Stack

_Storage_

-   Storage data is assigned to each account - persistent between function calls and transactions eg. currency balances, total supply etc
-   Storage is a key value store that maps 256-bit words to 256-bit words
-   We cannot access storage line by line within contract. Costs to read data & costs even more to store & modify data in storage.
-   Be mindful of what you store on storage - make sure that any derived data, cache is not kept on storage. Gas makes it too expensive and inefficient currently

_Memory_

-   Contract obtains a freshly created instance for each message call, an has access to the call payload, also called calldata
-   Memory is linear and can be addressed at bytes level - but any given time, reads are limited to 256 bits. writes can be 8 bit or 256 bit wide
-   Memory expands by a word(256 bit), when accessing (reading or writing) a previously untouched memory word (any offset within word)
-   As memory grows, gas needs to be paid. Gas price increases quadratically with memory expansion beware to use too much memory

_Stack_

-   EVM is a stack machine - all computations are performed on a data area called stack
-   Max size - 1024 elements and contains words of 256 bits
-   Access to stack is limited to top end in following ways..
    1. Copy one of the next 16 elements and to the top
    2. Swap top most with one of 16 elements below it
    3. All other operations take the topmost two (or more, depending on operation), execute and push the result to top of stack
-   It is possible to move stack elements to storage or memory or read from them
-   It is not possible to access deeper elements of stack without first removing the top

### Logs

-   Logs is used by solidity to implement events"
-   Logs store events data in specially indexed data structure that can be access at a block level
-   Contracts cannot access logs data after it is created but they can efficiently access from outside blockchain
-   We can set up event listeners to capture events as they are triggered within the EVM - note that event data does not sit onchain. Contracts cannot access historic logs once they are generated
-   Some part of log data is stored in bloom filters - bloom filters help to search data in efficient and cryptographically secure way

### Mesage Calls

-   Instruction set - EVM OP Codes and their gas usage is documented in solidity
-   All instructions operate on basic data types, 256 bit words or slices of memory
-   Contracts can call other contracts or send Ether to non-contract accounts via message calls
-   Every transaction has a top-level msg call which inturn can create more message calls. Message calls are similar to txns - a txn can be a bunch of msg calls
-   Contract can decide how much of its remaining gas should be sent to inner message call & how much it can retain
-   Out of gas exception is put on top of stack - any exception even in inner call bubbles up to top of stack in solidity
-   Contract on execution can return data to a pre-allocated location in caller's memory. This location is allocated by caller itself
-   Calls are limited by stack limit depth of 1024 - for more complex calls, loops are preferred over recursive calls
-   Only 63/64th of gas can be forwarded to a message call - this places a practical depth limit of 1000. Anything beyond this throws an exception - out of gas

### Delegate Calls

-   A delegate call is similar to message call with one exception - code of the target address is executed in the context of calling contract. So msg.sender and msg.value points to the caller address instead of target address
-   This means a contract can dynamically load code from another address at runtime. Storage, current address and balance still refer to calling contract, only code is taken from target address
-   This feature is used in libraries - library is pre-compiled code available to any address. Complex code can be stored in libraries and called in run-time

### Deactivate & Self destruct

-   Only way to remove code from a contract address is by running selfdestruct operation
-   Remaining ether will be sent to a designated target. Storage and code is removed from address
-   Any eth sent to contract after self destruction is lost forever - very risk to do this in practice
-   Even if self destruct is used, old data is retained mostly by nodes & will be visible onchain - so destruct is not like a gard disk elimination. Its history cannot be destructed

---
