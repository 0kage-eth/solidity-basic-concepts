//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/*
 /// @title: Understanding Data Locations and Assignments
 * @author: 0Kage
 * @notice: Explains assignment rules when data is moved between storage and memory
 * @notice: Read notes in DATALOCATIONS.md for more on this
 */
contract DataAssignment {

    /**
     * @dev Since no explicity location is assigned, by default, this variable is allocated space in 'storage'
     */
    uint256[] public membershipIds;

    /**
     * @dev notice that membershipList data is stored in memory
     */
    function analyzeMemberIds(uint256[] memory membershipList) public returns(uint256){

        /**
         * @dev This is a valid instruction
         * @dev Note that this copies whole array to storage
         * @dev Whatever changes are made to users will not change userList data since we have copied entire array
         */
        membershipIds = membershipList;

        /**
         * @dev this again is a valid instruction
         * @dev in this case, a reference pointer is created to data location of membershipIds in Storage
         * @dev any change in localMemberIds will also change data in Members
         */
        uint256[] storage _localMemberIds = membershipIds;

        /**
         * @dev updating localMemberIds will update membershipIds as well
         */
        _localMemberIds.push(15);

        /**
         * @dev update first element in membershipIds will update localMemberIds
         * @dev following will change the second element of membershipIds to 35
         */
        membershipIds[0] = 35;
        membershipIds[1] = _localMemberIds[0];

        /**
         * @dev in this case, reference point of membershipIds is passed to largestId function
         * @dev any change inside function would indeed change membershipIds[] array in storage
         */
        uint256 _largest = largestId(membershipIds);

        /**
         * @dev in this case a new copy in memory is created and sent to smallestId function
         * @dev any change to array, even if possible, will not change the array originally stored in storage
         */
        uint256 _smallest = smallestId(membershipIds);

        return _largest + _smallest;

    }

    /**
    * @dev note that here I have to give 'view' tag to this function
    * @dev can't use pure because we are using variables stored in current environment
    */
    function largestId(uint256[] storage memberIds) internal view returns(uint256){
        // dummy function calculates largest value in array
        return memberIds.length;
    }

    /**
    * @dev note that here I can pass as 'pure' because memberIds is a memory variable
    * @dev a fresh memory instance is being allocated without any connection to chain
    */
    function smallestId(uint256[] memory memberIds) public pure returns(uint256){
        // dummy function calculates smallest value in array
        return memberIds.length;
    }
}