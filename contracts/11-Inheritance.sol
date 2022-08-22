//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


    contract Owned {
        address payable owner;
        constructor() {owner = payable(msg.sender);}
    }


    /**
     * @dev contract is inherited from Owned
     * @dev Destructible can access all non-private members including
     * @dev internal functions and state variables
     */
    contract Destructible is Owned {

        event Destroyed(string message);

        /**
         * @dev virtual here denotes function behavior can change in derived class
         */
        function destroy() virtual public {
            if(msg.sender == owner) {
                emit Destroyed("Calling destroy from Destructible contract");
                selfdestruct(owner);
            }
        }        
    }

    /**
     * @dev Polymorphism - multiple inheritance 
     * @dev Owned is also a base class of Destructible, yet there is only a single instance of Owned
     */
    contract Boom is Destructible {
        /**
         * @dev making it virtual allows function to be overriden by derived class
         * @dev super.destroy() calls the function in base class one level above (in this case Destructible)
         */
        function destroy() virtual override public {
            emit Destroyed("Calling destroy from within Boom contract");
            super.destroy();
        }
    }

    /**
    * @dev Further inheritance of Nuke Contract
    */
    contract Nuke is Boom {

        /**
         * @dev only override - all derived classes will no longer be able to modify function
         * @dev note that I did not use super -> instead calling destroy function of super seniot contract Destructible
         */
        function destroy() override public {
            emit Destroyed("Calling destroy from within Boom contract");
            Destructible.destroy();
            
        }
    }