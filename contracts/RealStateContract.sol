// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
library Shared {
    struct RealState {
        string city;
        string street;
        uint number;
        uint meters;
        uint registration;
        string owner;
    }
}

contract RealStateContractCities {
    mapping( string => Shared.RealState[]) public realStateMap;
    function getRealStateByCity (string calldata _city) public view returns(Shared.RealState[] memory) {
        return realStateMap[_city];
    }
    function addRealState (Shared.RealState calldata realState) public {
        realStateMap[realState.city].push(realState);
    }

}


contract RealStateContract{
    struct RealState {
        string city;
        string street;
        uint number;
        uint meters;
        uint registration;
        string owner;
    }
    RealState[] public realStateArray;
        function addRealState(string calldata _city, string calldata _street, 
            uint _number, uint _meters, uint _registration, string calldata _owner) public {

        
              realStateArray.push(RealState(_city,_street,_number,_meters,_registration,_owner));

    }
function getRealStateByRegistration (uint _registration) public view returns(RealState memory) {
        for(uint i =0; i < realStateArray.length; i++){
            if (realStateArray[i].registration == _registration){
                return realStateArray[i];
            }
        }
        revert("Not found RealState with this registration");

    }
function deleteRealStateByRegistration(uint _registration) public {
        for(uint i =0; i < realStateArray.length; i++){
            if (realStateArray[i].registration == _registration){
                delete realStateArray[i];

                for(uint j =i; j < realStateArray.length-1; j++){
                    realStateArray[j] = realStateArray[j+1];
                }

                realStateArray.pop(); // delete the last
                // Important to reduce -1 the leght of array

                return; // for finish method
            }
        }
    }
    function getRealStateByCity (string calldata _city) public view returns(RealState[] memory) {
        uint resultLength = 0;
        for(uint i =0; i < realStateArray.length; i++){
            if (keccak256(bytes(realStateArray[i].city)) == keccak256(bytes(_city))){
                resultLength++;
            }
        }
        RealState[] memory rsReturn = new RealState[](resultLength);
  uint positionInsert = 0;
        for(uint i =0; i < realStateArray.length; i++){
            if (keccak256(bytes(realStateArray[i].city)) == keccak256(bytes(_city))){
                rsReturn[positionInsert] = realStateArray[i];
                positionInsert++;
            }
        }

        return rsReturn;
    }



}
