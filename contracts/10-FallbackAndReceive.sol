//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract FallbackAndReceiveTest{

    Test private s_t;

    constructor() {
        s_t = new Test();
    }

    /**
     * @dev CASE 1 - transfer eth without calldata
     * @dev no call data & value transfer - this should trigger receive() function
     * @dev expect the Received event to be emitted 
     */
    
    function callTest() public payable returns(bool){
        (bool success, ) = address(s_t).call{value: msg.value}("");
        require(success, "Transfer failed");
        return success;
    }

    /**
     * @dev CASE 2 - call a non-existent function in Test contract
     * @dev since we send call data, fallback() function has to be triggered
     * @dev expect FallbackAlert event to be emitted
     */

    function callTestWithoutCallData() public returns(bool){

        (bool success, ) = address(s_t).call(abi.encodeWithSignature("nonExistentFunction()"));
        return success;
    }

    /**
     * @dev CASE 3 - transfer eth with call data
     * @dev since call data is provided, fallback() function will be triggered
     * @dev expect the FallbackAlert event to be emitted
     */

    function callTestTransferWithoutCallData() public payable returns(bool){
        (bool success, ) = address(s_t).call{value: msg.value}(abi.encodeWithSignature("nonExistentFunction()"));

        require(success, "Transfer failed");
        return success;
    }

}


/**
 * @dev this contract will receive funds. Defining receive and callback here
 */
contract Test{

    event Received(address sender, uint256 value);
    event FallbackAlert(address sender, bytes data);

    /**
     * @dev receive() gets triggered when sender sends a message call without data to this address
     * @dev note that only 2300 gas is allowed
     */
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    /**
     * @dev fallback() gets triggered when function call does not match signature in contract
     * @dev or when callData is empty and receive is not implemented
     * @dev gas allowed is only 2300
     */

    fallback(bytes calldata input) external payable returns (bytes memory) {
        emit FallbackAlert(msg.sender, input);

        return "";
    }

    
}