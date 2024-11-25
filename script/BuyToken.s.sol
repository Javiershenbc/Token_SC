// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract BuyTokens is Script {
    function run() external payable {
        address tokenAddress = 0x9E6D2C68921ac11fCD57A8EEb062f7EE31e94378; // Reemplaza con la dirección del contrato
        Token token = Token(payable(tokenAddress));

        vm.startBroadcast();

        // Comprar tokens
        uint256 maticToSend = 0.01 ether; // Cantidad de MATIC a enviar
        token.buyTokens{value: maticToSend}();
        console.log("Bought tokens worth:", maticToSend, "MATIC");

        vm.stopBroadcast();
    }
}
