// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    // direción del minter, cartera que puede iniciar la generación de nuevos tokens
    address public minter;


    constructor() payable ERC20("Bmiw", "BMIW") {
        // asignación del minter inicial
        minter = msg.sender;
    }

   function mint(address account, uint256 amount) public {
        require(msg.sender == minter, 'Error, msg.sender is not the minter');
        _mint(account, amount);
    }
    function passMinterRole(address nuevoMinter) public returns (bool){
        // restriccion que se tiene que cumplir
        require(msg.sender == minter, 'Error, msg.sender is not the minter');
        minter = nuevoMinter;
        return true;
    }

}
