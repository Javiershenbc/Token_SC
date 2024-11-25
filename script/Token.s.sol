// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();

        // Desplegar el contrato
        Token token = new Token();
        console.log("Token deployed to:", address(token));

        // Pre-mint tokens para el contrato
        token.mint(address(token), 100000 * 10 ** token.decimals());
        console.log("Minted tokens to contract address.");

        vm.stopBroadcast();
    }
}
