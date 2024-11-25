// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

contract ViewBalance is Script {
    function run() external {
        address contractAddress = 0x9E6D2C68921ac11fCD57A8EEb062f7EE31e94378; // Reemplaza con la dirección del contrato

        // Mostrar el balance de MATIC del contrato
        uint256 balance = contractAddress.balance;
        console.log("Contract balance in MATIC:", balance);
    }
}
