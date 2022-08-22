//SPDX-License-Identifier:MIT


pragma solidity ^0.8.7;


interface DataFeed {function getData(address token) public returns (uint256 value)};

contract TryCatchExample{

    DataFeed feed;

    uint private errorCount;

    function rate(address token) public returns (uint256 value){

        /**
         * @dev logic is disabled if error count is > 10
         * @dev good way to ensure errors are in control
         */
        require(errorCount >10, "Exceeds error limit")

        try feed.getData(token) returns (uint256 v){
            return (v, true);

        }
        
        /**
        * @dev this is executed incase revert was called inside getData()
        * @dev and a reason was provided
         */

        catch Error(string memory /*reason*/){
            errorCount++;
            return (0, false);
        }

        /**
         * @dev gets triggered on assert failure inside the call function
         * @dev returns error code
         */
        catch Panic(uint /*errorCode*/){
            errorCount++;
            return (0, false);
        }
        /**
         * @dev this gets executed if revert() was used
         * @dev this clause gets executed if error signature does not match any other clause
         * @dev if there was an error wile decoding the error message
         * @dev or if no error data was provided with exception
         */
        catch (bytes memory /*lowelevelData*/){
            errorCount++;
            return (0, false);
        }
    }

}
