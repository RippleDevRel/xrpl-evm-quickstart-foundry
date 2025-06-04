// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleERC20.sol";

contract SimpleERC20Test is Test {
    SimpleERC20 public token;
    address public owner = address(1);
    address public user = address(2);

    function setUp() public {
        vm.prank(owner);
        token = new SimpleERC20("Test Token", "TEST", 1000);
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), 1000 * 10**18);
        assertEq(token.balanceOf(owner), 1000 * 10**18);
    }

    function testMinting() public {
        vm.prank(owner);
        token.mint(user, 100 * 10**18);
        
        assertEq(token.balanceOf(user), 100 * 10**18);
        assertEq(token.totalSupply(), 1100 * 10**18);
    }

    function testTransfer() public {
        vm.prank(owner);
        token.transfer(user, 50 * 10**18);
        
        assertEq(token.balanceOf(user), 50 * 10**18);
        assertEq(token.balanceOf(owner), 950 * 10**18);
    }
}