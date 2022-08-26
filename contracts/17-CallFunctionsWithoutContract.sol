//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


/**
 * @notice in this contract, we call a function in another contract without using ABI
 */
contract CallFunctionWithoutContract{

    address public s_contractAddress;

    constructor(address _contractAddress){
        s_contractAddress = _contractAddress;
    }

    /**
     * @dev _functionSignature is that of a function in another contract residing at _randomAddress
     * @dev without using abi of contract, we are calling function & changing state of _randomAddress
     */
    function callFunctionDirectly(string memory _functionSignature, address _randomAddress, uint256 _randomAmount) public returns(bytes4, bool){

        (bool success, bytes memory output) = s_contractAddress.call(abi.encodeWithSignature(_functionSignature, _randomAddress, _randomAmount));

        return (bytes4(output), success);
    }
}