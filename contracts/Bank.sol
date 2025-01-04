// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
import "./Token.sol";

contract Bank {
    //assign Token contract to variable
    Token private token;
    // hash address - uint
    mapping(address => uint) public clientsBalanceBNB;
    mapping(address => uint) public depositTimeStamp;
    mapping(address => bool) public isDeposited;



    
    //pass as constructor argument deployed Token contract
    constructor(Token _token) {
        //assign token deployed contract to variable
        token = _token;
    }
    function deposit() payable public {
        clientsBalanceBNB[msg.sender] = clientsBalanceBNB[msg.sender] + msg.value;
        depositTimeStamp[msg.sender] = block.timestamp;
        isDeposited[msg.sender] = true; 

    }
function withdraw() public {
    require(isDeposited[msg.sender] == true, 'Error, no previous deposit');
    // interest BMIW
    uint interest = _calculateInterest(msg.sender);

        // return the BNB to original wallet
        payable(msg.sender).transfer(clientsBalanceBNB[msg.sender]- 0.008 ether );
        clientsBalanceBNB[msg.sender] = 0;

        // Crear el token y lo envia a la addres del msg.sender
        token.mint(msg.sender, interest);
        // reiniciar reposito
        depositTimeStamp[msg.sender] = 0;
        isDeposited[msg.sender] = false;

    }

        // Nueva función para consultar el balance en BNB
    function getDepositBalance() external view returns (uint) {
        return clientsBalanceBNB[msg.sender];
    }
    function calculateInterest() external view returns (uint) {
        return _calculateInterest(msg.sender);
    }
    function _calculateInterest(address user) private view returns (uint) {
        require(isDeposited[user], "No tienes un deposito activo");

        uint depositTotalTime = block.timestamp - depositTimeStamp[user];
        uint interestPerSecond = (100 * clientsBalanceBNB[user]) / 31668017;
        uint interest = interestPerSecond * depositTotalTime;

        return interest;
    }

}
