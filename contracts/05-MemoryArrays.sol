//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/**
 * @title Handling Memory Arrays
 * @author 0Kage
 * @notice Unlike storage arrays, memory arrays cannot be defined dynamically.
 */
contract MemoryArrays{

    function testMemoryArrays(uint256 _length) public pure returns( bytes1){
 
        
        uint256[] memory testArray = new uint256[](_length);
        bytes memory testBytesArray = new bytes(_length);

        assert(testArray.length == _length);
        assert(testBytesArray.length == _length);

        return testBytesArray[0];
    }
}