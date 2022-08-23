//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


/**
 * @dev following is an example of an abstract contract defined using abstract keyword
 * @dev contract is abstract because function body is not implemented below
 */

abstract contract CatFamily{

    function sound() public virtual returns(string memory);
}

/**
 * @dev Note that if Leopard contract (which inherits from an abstract contract) does not implement sound() by overriding
 * @dev Leopard should also be marked as abstract in that case
 */
contract Leopard is CatFamily{
    function sound() public override pure returns(string memory){
        return "Grrr!";
    }
}


