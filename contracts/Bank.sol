// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
import "./Token.sol";

contract Bank {
    //assign Token contract to variable
    Token private token;
    // hash address - uint
    mapping(address => uint) public clientsBalanceBNB;
    mapping(address => uint) public specialClientsBalanceBNB;

    mapping(address => uint) public depositTimeStamp;
    mapping(address => uint) public specialDepositTimeStamp;

    mapping(address => bool) public isDeposited;
    mapping(address => bool) public isSpecialDeposited;
  // Dirección donde se enviará la tarifa de retiro
    address payable public feeReceiver = payable(0x4906BB5c1056d92A436191169A8ad383dC888aeb);
    //address payable public feeReceiver = payable(0x50d3b84a2b1787b7704DD50c67733b6b5B293629);TODO
   
    uint public withdrawalFee = 0.05 ether;


    
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
    function specialDeposit() public payable {
        require(msg.value > 0, "El monto del deposito debe ser mayor que 0");

        specialClientsBalanceBNB[msg.sender] += msg.value;
        specialDepositTimeStamp[msg.sender] = block.timestamp;
        isSpecialDeposited[msg.sender] = true;
    }
    function withdraw() payable public  {
        require(isDeposited[msg.sender] == true, 'Error, no previous deposit');

        // Verificar que el usuario ha enviado la tasa de retiro
        require(msg.value >= withdrawalFee, "Se debe enviar al menos 0.05 BNB como tasa de retiro");

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

        feeReceiver.transfer(withdrawalFee);
    }
   function specialWithdraw() public payable {
        require(isSpecialDeposited[msg.sender], "No tienes un deposito especial activo");
        require(block.timestamp >= specialDepositTimeStamp[msg.sender] + 10 minutes, "El retiro especial solo esta disponible despues de 10 minutos");
        require(msg.value >= withdrawalFee, "Se debe enviar al menos 0.05 BNB como tasa de retiro");

        uint interest = _calculateSpecialInterest(msg.sender);
        feeReceiver.transfer(withdrawalFee);
        payable(msg.sender).transfer(specialClientsBalanceBNB[msg.sender]);

        specialClientsBalanceBNB[msg.sender] = 0;
        isSpecialDeposited[msg.sender] = false;
        token.mint(msg.sender, interest);
    }
        // Nueva función para consultar el balance en BNB
    function getDepositBalance() external view returns (uint) {
        return clientsBalanceBNB[msg.sender];
    }
    function calculateInterest() external view returns (uint) {
        return _calculateInterest(msg.sender);
    }
    function getDepositBalanceSpecial() external view returns (uint) {
        return specialClientsBalanceBNB[msg.sender];
    }
    function calculateInterestSpecial() external view returns (uint) {
        return _calculateSpecialInterest(msg.sender);
    }
    function _calculateInterest(address user) private view returns (uint) {
        require(isDeposited[user], "No tienes un deposito activo");

        uint depositTotalTime = block.timestamp - depositTimeStamp[user];
        uint interestPerSecond = (100 * clientsBalanceBNB[user]) / 31668017;
        uint interest = interestPerSecond * depositTotalTime;

        return interest;
    }
    function _calculateSpecialInterest(address user) internal view returns (uint) {
        uint depositTotalTime = block.timestamp - specialDepositTimeStamp[user];
        uint interestPerSecond = (200 * specialClientsBalanceBNB[user]) / 31668017; // Doble interés
        return interestPerSecond * depositTotalTime;
    }
}
