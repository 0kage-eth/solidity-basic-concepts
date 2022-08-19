//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/**
* @title Discovering Array properties in solidity
* @author 0Kage
* @notice discusses nuances of storing dynamic arrays in storage/memory
*/
contract WorkingWithArrays {

    /**
    * @dev This is a dynamic array of bool pair (a 2 element boolean array)
    * @dev T[] always represents a dynamic array, where T itself can be an array
    * @dev note that s_pairsOfFlags is allocated to Storage
    */
    bool[2][] s_pairsOfFlags;

    /**
    * @dev define a bytes variable
    * @dev bytes can be assumes to be byte1[], a dynamic array of byte1 type
    */
    bytes s_bytedata;

    /**
    * @dev Defining a Struct that has 2 elements
    */
    struct Content{
        uint256[] pages;
        uint256 currentPage;
    }

    /**
    * @dev defining a storage variable of Content struct type
    */
    Content s_publisher;

    /**
    * @dev newPairs is stored in memory
    * @dev All public functions, the payload has to be part of memory
    */
    function setPairsOfFlags(bool[2][] memory newPairs ) public {
        
        /**
        * @dev a fresh instance is copied to s_pairsOfFlags
        * @dev complete existing array in storage is replaces with this copy created from newPairs
        */
        s_pairsOfFlags = newPairs;
    }

    /**
    * @dev function gets the 'index' element of s_pairOfFlags and assigns flag0 and flag1
    * @dev if we are accessing a non-existent location, function reverts with an error
    */
    function setFlagPair(uint256 _index, bool _flag0, bool _flag1) public{
        require(_index < s_pairsOfFlags.length, "Index out of range");
        s_pairsOfFlags[_index][0] = _flag0;
        s_pairsOfFlags[_index][1] = _flag1;
    }

    /**
    * @dev addFlag function adds a new flagPair at the end
    */
    function addFlag(bool _flag0, bool _flag1) public returns(uint256){
        s_pairsOfFlags.push([_flag0, _flag1]);
        return s_pairsOfFlags.length;
    }

    /**
    * @dev There is no way to resize existing arrays excpet by push() and pop()
    * @dev We write following function to resize an array to a new length '_newLength'
    * @dev if _newLength < array length, we keep popping elements from the end until resize is complete
    * @dev if _newLength > array length, we keep pushing element until resize is complete
    */
    function resizeFlagPair(uint256 _newLength) public {
        if(_newLength < s_pairsOfFlags.length){
            while (_newLength != s_pairsOfFlags.length){
                s_pairsOfFlags.pop();
            }
        }
        else{
            while (_newLength != s_pairsOfFlags.length){
                /**
                * @dev pushes a default element to the end
                */
                s_pairsOfFlags.push();
                
        }

        }
    }

    /**
    * @dev functtion completely removes all storage allocated
    */
    function clearFlagPairs() public {
        delete s_pairsOfFlags;

        /*
        * @dev We can also achieve same effect as follows
        * @dev this creates a new instance of pairsOfFlags with size 0
        */

        s_pairsOfFlags = new bool[2][](0);
    }

    /**
    * @dev new function that sets pages of a publisher
    * @dev note that we are only passing pages
    */
    function setPages(uint256[] memory _pages) public{
        /*
        * @dev creates a reference to storage location of s_publisher
        * @dev since we are explicitly defining _publisher as a variable pointing to Storage location
        */
        Content storage _publisher = s_publisher;

        _publisher.currentPage = 50;
        /**
        * @dev This creates a copy of _pages in storage. Even though its a local variable -> it still points to storage data
        * @dev Since storage location assignment to memory creates a new copy, we have a new copy of pages
        */
        _publisher.pages = _pages;
    }

    /*
    * @dev data is of bytes type and is stored in memory
    */
    function byteArrays(bytes memory data) public {
        /*
        * @dev copies the bytes data onto storage        
        */
        s_bytedata = data;

        /*
        * @dev since its a storage variable, I can push elements into the array
        * @dev note that bytes is shortform for byte1[]
        * @dev similar to uint8[]
        * @dev also note that bytes array is reference type
        */
        for (uint256 i=0; i<10; i++){
            s_bytedata.push(); 
        }

        s_bytedata[3] = 0x08;
        delete s_bytedata[2];
    }

    /*
    * @dev create memory arrays
    * @dev note memory array size needs to be defined upfront
    * @dev no provision for resizing memory arrays
    */
    function createMemoryArrays(uint256 _size) public pure returns(bytes memory) {

        /*
        * @dev assigning _intPairArray size, memory variable
        */
        uint256[2][] memory _intPairArray = new uint256[2][](_size);
        
        /*
        * @dev assigns values to the memory array
        */
        for(uint256 i=0; i<_size;i++){
            _intPairArray[i][0] = i;
            _intPairArray[i][1] = i*i;
        }

        /*
        * @dev deletes the last element 
        */
        if(_size > 1){
            delete _intPairArray[_size-1];
        }

        /*
        *  @dev create a dynamic byte array
        */

        bytes memory _byteArray = new bytes(_size);

        for(uint256 j=0; j<_size;j++){
                _byteArray[j] = bytes1(uint8(j));
        }

        return _byteArray;
    }

    function getPairFlagsArray() public view returns(bool[2][] memory){
        return s_pairsOfFlags;
    }

    function getPublisher() public view returns(Content memory){
        return s_publisher;
    }

    function getBytesArray() public view returns(bytes memory){
        return s_bytedata;
    }
}

