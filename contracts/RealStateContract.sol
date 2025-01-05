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

    //address payable public admin = payable(0x4906BB5c1056d92A436191169A8ad383dC888aeb);
    address payable public admin = payable(0x50d3b84a2b1787b7704DD50c67733b6b5B293629);
    mapping(address => bool) public authorizedAddresses;
     modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedAddresses[msg.sender], "Only authorized addresses can perform this action");
        _;
    }
    function addAuthorizedAddress(address newAddress) public onlyAdmin {
        authorizedAddresses[newAddress] = true;
    }
    function getRealStateByRegistration(uint _registration) public view returns (Shared.RealState memory) {
        Shared.RealState memory realState = realStateMap[_registration];
        require(realState.registration != 0, "Not found RealState with this registration");
        return realState;
    }

    function addRealState(Shared.RealState calldata realState) public onlyAuthorized {
        //require(realStateMap[realState.registration].registration == 0, "RealState with this registration already exists");
        realStateMap[realState.registration] = realState;
    }

    function deleteRealStateByRegistration(uint _registration) public onlyAuthorized {
        require(realStateMap[_registration].registration != 0, "Not found RealState with this registration");
        delete realStateMap[_registration];
    }

}

