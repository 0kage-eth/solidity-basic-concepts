# EVENTS

## Basics

-   Events give an abstraction on top of EVM's logging functionality
-   Applications can subscribe and listen to events using RPC interface of Ethereum client
-   When events are called, arguments are stored in transaction log, a special data structure in blockchain
-   logs are associated with address of contract, and incorporated into blockchain
-   logs stay so long as block is accessible
-   **Log and its events data is not accessible inside a contract**

-   We can add attributed `indexed` to upto 3 parameters
-   Indexing adds these paramaters a special data structure called `topics`
-   `topics` is different from `data` part of blog
-   Topic can hold a single word (32 bytes) - if we use reference type for indexed argument - keccak-256 hash of value is stored in topic
-   All paramaters without `indexed` are stored in `data` part of logs and abi encoded
-   Topics allow us to efficiently search for certain events
-   Hash of signature of event is one of the topics, except if you declared event with anonymous specifier

---

## Members

-   `event.selector` - for non-anonymous events, this is a bytes32 value containing `keccak256` hash of event signature (default topic)
