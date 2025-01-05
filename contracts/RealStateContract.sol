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

contract RealStateContractRegistrations {
    mapping(uint => Shared.RealState) public realStateMap;

    function getRealStateByRegistration(uint _registration) public view returns (Shared.RealState memory) {
        Shared.RealState memory realState = realStateMap[_registration];
        require(realState.registration != 0, "Not found RealState with this registration");
        return realState;
    }

    function addRealState(Shared.RealState calldata realState) public {
        //require(realStateMap[realState.registration].registration == 0, "RealState with this registration already exists");
        realStateMap[realState.registration] = realState;
    }

    function deleteRealStateByRegistration(uint _registration) public {
        require(realStateMap[_registration].registration != 0, "Not found RealState with this registration");
        delete realStateMap[_registration];
    }

}

