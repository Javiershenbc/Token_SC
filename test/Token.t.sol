// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Token.sol";

// Adjust the import path based on your project structure

contract TokenTest is Test {
    Token public token;

    address public owner = address(0x1);
    address public minter = address(0x2);
    address public user = address(0x3);

    function setUp() public {
        vm.prank(owner); // Simulate that `owner` deploys the contract
        token = new Token();
    }

    function testInitialSetup() public {
        // Check initial roles
        assertTrue(token.hasRole(token.DEFAULT_ADMIN_ROLE(), owner));
        assertTrue(token.hasRole(token.MINTER_ROLE(), owner));

        // Check token details
        assertEq(token.name(), "TOKEN");
        assertEq(token.symbol(), "MYTOK");
        assertEq(token.decimals(), 2);
    }

    function testMintByMinter() public {
        uint256 mintAmount = 100 * 10 ** token.decimals();

        // Grant MINTER_ROLE to `minter`
        vm.prank(owner);
        token.grantRole(token.MINTER_ROLE(), minter);

        // Mint tokens as `minter`
        vm.prank(minter);
        token.mint(user, mintAmount);

        // Check the balance of `user`
        assertEq(token.balanceOf(user), mintAmount);
    }

    function testMintNotAuthorized() public {
        uint256 mintAmount = 100 * 10 ** token.decimals();

        // Attempt mint by unauthorized user
        vm.prank(user);
        vm.expectRevert(
            abi.encodePacked(
                "AccessControl: account ",
                vm.toString(user),
                " is missing role ",
                vm.toString(token.MINTER_ROLE())
            )
        );
        token.mint(user, mintAmount);
    }

    function testGrantRoleOnlyAdmin() public {
        // Attempt granting role by a non-admin
        vm.prank(user);
        vm.expectRevert(
            abi.encodePacked(
                "AccessControl: account ",
                vm.toString(user),
                " is missing role ",
                vm.toString(token.MINTER_ROLE())
            )
        );
        token.grantRole(token.MINTER_ROLE(), user);
    }

    function testDecimals() public {
        assertEq(token.decimals(), 2);
    }
}
