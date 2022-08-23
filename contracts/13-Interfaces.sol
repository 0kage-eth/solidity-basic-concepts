//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/**
* @dev example used to explain concept of interfaces
* @dev interface is used to perform a set of operations without worrying about underlying implementation
* @dev primarily help in interacting with other contracts
* @dev good convention to start an interface with 'I'
*/
interface ICar{
    function color() external returns(bytes32);

    function maxSpeed() external returns (uint256);

    function name() external returns(string memory);
}



contract Tesla is ICar{
    function color() override public pure returns(bytes32){
        return "red";
    }

    function maxSpeed() override public pure returns(uint256){
        return 140;
    }

    function name() override public pure returns(string memory){
        return "Tesla";
    }
}