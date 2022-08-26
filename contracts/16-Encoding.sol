//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Encoding{


    uint256 public s_amount;
    address public s_someAddress;

    /**
    * @dev constructor is made payable so as to initially fund contract with Eth
    * @dev this is needed because we go on to test call functions that pay ether to other accounts later
    */
    constructor() payable {

    }


    // *****************LEARNING ENCODING & DECODING******************
    
    /**
    * @notice returns concatenated string combining two strings
    * @dev notice that we typecast bytes into string - only then is the encoded output readable
    * @dev passing strings 'hi there ' & '0Kage here' gives us outputs
    * @dev concatenated: hi there 0Kage here; encoded: 0x686920746865726520304b6167652068657265
    */
    function concatStrings(string memory _first, string memory _second ) public pure returns(string memory concatenated, bytes memory encoded){

        encoded = abi.encodePacked(_first, _second);
        concatenated = string(encoded);
    }

    /**
    *@notice in this function, we see difference of calling abi.encode() and abi.encodePacked()
    *@notice one returns the full bytes32, other returns a packed version of it
    *@dev makes a lot of differece from a gas perspective but need to be careful decoding packed data (while unpacking)
    *@dev passing 0Kage gives 0x304b616765 for packed & 
    *@dev for unpacked it is 0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000005304b616765000000000000000000000000000000000000000000000000000000
    *@dev unpacked version has leading zeroes and lagging zeroes but it is essentially the same
    *@dev note also that I can simply cast a string into bytes - I get the same output as packed encoding
    *@dev 
    */
    function packedVsUnpacked(string memory _random) public pure returns(bytes memory packed, bytes memory unpacked, bytes memory cast){
        packed = abi.encodePacked(_random);
        unpacked = abi.encode(_random);
        cast = bytes(_random);
    }

    /**
    * @notice example encodes a number, we can practically encode anything using solidity's abi.encode() function
    * 21212222 returns 0x000000000000000000000000000000000000000000000000000000000143ac3e
    */
    function encodeNumber(uint256 _number)public pure returns(bytes memory encoded){
        encoded = abi.encode(_number);
    }

    /**
    * @notice we can encode a string
    * @dev again, leading and lagging zeroes
    */
    function encodeString(string memory _random) public pure returns (bytes memory encoded){
        encoded = abi.encode(_random);
    }

    /**
    * @notice decode stuff
    * @dev while decoding, we need to specify type of variable that is being decoded
    * @dev run the function and notice that you get back 56 and "0Kage"
    */

    function decodeStuff() public pure returns(uint256 decodedNumber, string memory decodedString){
        decodedNumber = abi.decode(encodeNumber(56), (uint256));
        decodedString = abi.decode(encodeString("0Kage"), (string));
    }

    function decodeString(bytes memory _random) public pure returns(string memory decoded){
        decoded = abi.decode(_random, (string));
    }


    /**
    * @notice we can encode two strings - they are concatenated and then encoded
    * @notice you will see that lagging and leading zeroes of individual strings are retained 
    * @notice packed version tends to combine both withoutt any leading or lagging zeroes
    */

    function multiEncode(string memory _first, string memory _second) public pure returns(bytes memory packedEncode, bytes memory unpackedEncode){
        packedEncode = abi.encodePacked(_first, _second);
        unpackedEncode = abi.encode(_first, _second);

    }


    /**
    *@notice multiDecode() works the same way - we can specifiy the types of the variables we want to decode
    *@dev note that this will NOT work if the input strings were packed  (compiler does not understand how to decode without leading/lagging zeroes"
    */
    function multiDecode() public pure returns(string memory first, string memory second){
        (, bytes memory unpackedEncode) = multiEncode("0Kage ", "says hi");
        (first, second) = abi.decode(unpackedEncode, (string, string));        
    }

    /**
    * @notice unlike previous example, this worked
    * @dev - a packed string that uses 2 strings and encodes apacked variation can be unpacked by casting it to string
    * @dev string casting of bytes is allowed
    * @dev but this operation is super expensive in terms of gas - compiler has to do a lot of effort & hence expensive
    */
    function multiStringCastPacked() public pure returns(string memory casted){
            (bytes memory packedEncode, ) = multiEncode("0Kage ", "says hi");
            casted = string(packedEncode);

    }

    // ***************CALLING FUNCTIONS WITH BYTES DATA *********************

    // Using concepts of encoding and decoding, we can just execute trsnactions at bytecode level (although not recommended)
    // We can create a call function where 'data' is passed as byte code - data will contain function signature and parameter values
    // In the CONTRACTS.md, we discussed call function -> just like transfer & send, this is a low level function
    // Lets use call function to execute transactions with just the bytecode - we skip the ABI completely

    /**
    * @notice we start with a simple call without bytes data
    * @dev we looked at this earlier - this is a simple transfer
    * @dev Note that data here is passed as "". Since no data, it tries to find receive fallback function
    * @dev In next example, lets encode data and pass that into call function
    */
    

    function basicCall(address payable _to) public {

        (bool success, ) = _to.call{value: 1*10**18}("");
        require(success, "Transfer failed");
    }

    /**
    * @notice helper function - gets balance of current contract
    */

    function getBalance() public view returns (uint256) {

        return address(this).balance;
    }

    /**
    * @dev this is a sample function we define - using the signature of this function, we create bytes data
    * @dev that data is sent to call() function to get return data
    */
    function transfer(address someAddress, uint256 amount) public {
        // Some code
        s_someAddress = someAddress;
        s_amount = amount;
    }


    /**
    * @dev signature here refers to function signature with just name & data types of all inputs
    * @dev function returns a bytes4 data of function selector (name of function)
    * @dev keccak256() is an encryption algorithm like sha256
    */
    function getFunctionSelector(string memory signature) public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes(signature)));
    }   

    /**
    * @dev this is data in bytes format that can be sent to call()
    * @dev abi.encodeWithSelector takes bytes4 selector & parameters to convert into byte data 
    * @dev this bytes can then be passed to call function
    */
    function getDataToCallTransfer(string memory signature, address someAddress, uint256 amount)
    public
    pure
    returns (bytes memory)
    {
        return abi.encodeWithSelector(getFunctionSelector(signature), someAddress, amount);
    }

    /**
    * @dev function calls another function directly, given signature, address and amount
    */
    function callTransferFunctionDirectly(string memory signature, address someAddress, uint256 amount)
        public
        returns (bytes4, bool)
    {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount);
            abi.encodeWithSelector(getFunctionSelector(signature), someAddress, amount)
        );
        return (bytes4(returnData), success);
    }

    /**
    * @dev function calls another function directly, given signature, address and amount
    * @dev here we use encodeWithSignature that automatically returns a selector, given function signature
    * @dev unlike in previous function, we don't need to use getFunctionSelector(). Solidity does it for us
    */
    function callTransferFunctionDirectlyWithSignature(string memory signature, address someAddress, uint256 amount)
    public returns(bytes4, bool)
    {
        (bool success, bytes memory output) = address(this).call(abi.encodeWithSignature(signature, someAddress, amount));

        return (bytes4(output), success);
    }


    

}