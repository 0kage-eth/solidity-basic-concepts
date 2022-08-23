//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


library Search {

    function indexOf(uint[] storage self, uint value) public view returns(uint256){
        for(uint256 indx=0; indx<self.length; indx++){
            if(self[indx] == value) return indx;
        }
        return type(uint256).max;
    }
}


contract C {

    using Search for uint[];
    uint256[] private s_numbers;
    /**
     * @dev check if a value already exists in array
     * @dev if it doesn't, add -> else skip
     * @dev we use library function indexOf on array -> only when it returns false, we add the number
     */
    function addUnique(uint256 x) public returns(bool){
        if(s_numbers.indexOf(x) < type(uint256).max){
            s_numbers.push(x);
            return true;
        }
        return false;
    }

    function replace(uint256 _from, uint256 _to) public returns(bool){
        
        uint256 indx = s_numbers.indexOf(_from);
        /**
         * @dev checking if _from exists in the array,
         * @dev if it doesn't, there is nothing to replace
         * @dev if it does, find index and replace it with _to
         */
        if( indx != type(uint256).max){
            s_numbers[indx] = _to;
            return true;
        }
        return false;
    }

    function getNumbersArray(uint256 x) public view returns(uint256){
        return s_numbers[x];
    }
}