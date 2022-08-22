// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


/**
 * @title Mapping example by building a simple ERC 20 token implementation
 * @author 0Kage
 * @notice We use concept of mapping to build a balances table for ERC 20 token
 * @dev mapping is a virtual hashtable and its allocation happens in Storage
 */
contract MappingsERC20 {

    /**
     * @dev name of erc20 token
     */
    string private s_name;

    /**
     * @dev symbol of erc20 token
     */
    string private s_symbol;

    /**
     * @dev total supply of token
     */
    uint256 private s_totalSupply;

    /**
     * @dev decimals for expressing token value
     * @dev default value 18 to be consistent with eth-wei
     */
    uint8 private s_decimals = 18;

    /**
     * @dev basic mapping that maps an address to its balance
     */
    mapping(address => uint256) private s_balances;

    /**
     * @dev allowances is a more complex mapping
     * @dev allowances map allows ERC20 contract to keep tab of all spending allowance
     * @dev given to various contracts by user
     * @dev key for outer mapping is user, key for internal mapping is address of contract that has access to user tokens
     */
    mapping (address => mapping(address =>uint256)) private s_allowances;





    /**
     * @dev event definitions
     */
    event Transfer(address sender, address recepient, uint256 value);
    event Approval(address sender, address spender, uint256 amount);

    /**
     * @dev constructor - initialize with name and symbol
     */
    constructor(string memory _name, string memory _symbol) {
        s_name = _name;
        s_symbol = _symbol;
    } 


 


    /**
     * @notice transfer function to send funds from _sender to _recepient
     * @dev note that this function is internal - can only be accessed inside contract or inside inherited contracts
     * @param _sender address of sender
     * @param _recepient address of recepient
     * @param _amount amount of transfer in wei
     */
     function _transfer(address _sender, address _recepient, uint256 _amount) internal {
        /**
         * @dev dont allow minting and burning in transfer. handle them as special case
         */
        require(_sender != address(0), "ERC 20 transfer from zero address");
        require(_recepient != address(0), "ERC 20 transfer to zero address");
        require(s_balances[_sender] >= _amount, "Insufficient amount");

        s_balances[_sender] -= _amount;
        s_balances[_recepient] += _amount;

        /**
         * @dev emit a Transfer event
         */
        emit Transfer(_sender, _recepient, _amount);
     }


    /**
     * @dev transferFrom is used by current token to transfer tokens to a recepient
     * @param _sender wallet owner of current ERC 20 token who intends to make a transfer
     * @param _recepient recepient of ERC 20 token transfer
     * @param _amount amount of ERC 20 tokens to be transfer
     * @return bool true if transfer if successful, false otherwise
     */
    function transferFrom(address _sender, address _recepient, uint256 _amount ) public returns(bool) {
        require(s_allowances[_sender][msg.sender] >= _amount, "ERC20: Allowance not high enough");

        s_allowances[_sender][msg.sender] -= _amount;
        _transfer(_sender, _recepient, _amount);    
        return true;
    }

    /**
     * @notice function approves allowance for ERC20 token to be transferred from user wallet
     * @dev add amount to allowance if wallet balance more than approval amount
     */
    function _approve(address _spender, uint256 _amount) internal {
        require(_spender != address(0), "Spender cannot be zero address");
        require(s_allowances[msg.sender][_spender] + _amount <= msg.sender.balance, "Approval amount exceeds account balance");

        s_allowances[msg.sender][_spender] += _amount;
        emit Approval(msg.sender, _spender, _amount);

    }


    //public functions

    /**
     * @notice transfer function transfers ERC 20 tokens from EOA to other account
     */
     function transfer(address _recepient, uint256 _amount) public virtual override returns(bool) {

        _transfer(msg.sender, _recepient, _amount);
        return true;
     }   


    function approve(address spender, uint256 amount) public vurtual override returns(bool){
        _allowance(msg.sender, spender, amount);
        return true;
    }

    /**
    * @notice GetName    
    */
    function name() public view virtual override returns(string memory){
        return s_name;
    }

    function symbol() public view virtual override returns(string memory){
        return s_symbol;
    }

    function decimals() public view virtual override returns(uint8){
        return s_decimals;
    }

    function balanceOf(address account) public view virtual override returns(uint256){
        return s_balances[account];
    }

    function allowance(address owner, address spender) public view virtual override returns(uint256){
        return s_allowances[owner][spender];
    }


}