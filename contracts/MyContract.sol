// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;


contract MyContract {
    address[16] public tikets;
    uint public balanceWei = 0;
    //address payable public admin  = payable(0x4906BB5c1056d92A436191169A8ad383dC888aeb);
    address payable public admin  = payable(0x50d3b84a2b1787b7704DD50c67733b6b5B293629);

     event simpleConsoleLog(
        string mensaje
    );

    function buyTiket(uint tiketIndex) payable public returns (bool) {
        // Comprobación
        require(tiketIndex >= 0 && tiketIndex <= 15);
        // Verificación de que el tiket no está vendido
        require(tikets[tiketIndex] == address(0), "El tiket ya ha sido comprado");
        require(msg.value == 0.02 ether, "Insuficient amount of BNB");
        balanceWei += msg.value;

        bool sucess = true;
        
        if ( tikets[tiketIndex] == address(0) ){
            // msg.sender address del usuario que invoco al contrato
            tikets[tiketIndex] = msg.sender;
            emit simpleConsoleLog("Tiket comprado");
            
        } else {
            sucess = false ;
        }

        return sucess;
    }

    function getTikets() public view returns (address[16] memory) {
            return tikets;
        }
 function transferBalanceToAdmin () public {
        require(msg.sender == admin, "No eres el admin");
        
        admin.transfer(balanceWei);
        balanceWei = 0;
    }

    function changeAdmin (address adress) public {
        require(msg.sender == admin, "No eres el admin");
        admin  = payable(adress);
        emit simpleConsoleLog("Admin cambiado");
    }
 // Nueva función para consultar los balances
    function getBalanceInfo() public view returns (uint contractBalance, uint balanceWeiStored) {
        return (address(this).balance, balanceWei);
    }
    
}