//SPDX-License-Identifer: MIT

pragma solidity ^0.8.7;

/**
 * @notice this contract will be created inside of another contract
 */
contract Demo{

    uint256 public s_x;

    /**
     * @dev by making it payable, we are allowing an external function to 
     * @dev create this contract and fund it simultaneously
     */
    constructor(uint256 _x) payable{
        s_x = _x;
    }


}

/**
 * @notice I create a demo contract from within a function of this contract
 */
contract CreateDemoContract {

    /**
     * @dev we can store contract itself as a variable
     * @dev here I am initializing contract using 'new' constructor
     * @dev 'new' basically initializes constructore and adds the contract code
     * @dev contract code is already defined at this point
     */

    Demo private demoContract = new Demo(22);

    /**
     * @dev here I create a fund a Demo contract inside of a function
     */
    function createAndFundDemoContract(uint256 _x, uint256 _fund) {
        Demo demo = new Demo{value: _fund}(_x);
    }



}