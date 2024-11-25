// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract MintTokens is Script {
    function run() external {
        address tokenAddress = 0xe8e22A7D86C89A9EbF3e404fe24e4A98dF49bcDB; // Dirección del contrato desplegado
        Token token = Token(payable(tokenAddress));

        vm.startBroadcast();

        // Dirección que recibirá los tokens
        address recipient = 0x9FbA7D4803669E3d68c6bbC5B58ddC8dB6beed9f; // Cambiar por la dirección deseada
        uint256 amount = 100 * 10 ** token.decimals();

        // Mintear tokens
        token.mint(recipient, amount);
        console.log("Minted", amount, "tokens to", recipient);

        vm.stopBroadcast();
    }
}
