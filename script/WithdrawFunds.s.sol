// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract WithdrawFunds is Script {
    function run() external {
        address tokenAddress = 0x9E6D2C68921ac11fCD57A8EEb062f7EE31e94378; // Reemplaza con la dirección del contrato
        Token token = Token(payable(tokenAddress));

        vm.startBroadcast();

        // Retirar fondos
        token.withdraw();
        console.log("Funds withdrawn by admin.");

        vm.stopBroadcast();
    }
}
