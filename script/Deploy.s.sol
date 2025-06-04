// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/StdUtils.sol";
import "src/SimpleERC20.sol";

contract Deploy is Script {
    function run() public {
        // Deploy the ERC20 token
        bytes32 pkey = vm.envBytes32("PRIVATE_KEY");
        address deployer = vm.addr(uint256(pkey));
        
        console.log("Deploying from address:", deployer);
        console.log("Deployer balance before:", deployer.balance);
        
        vm.startBroadcast(uint256(pkey));
        
        // Deploy the SimpleERC20 contract
        SimpleERC20 token = new SimpleERC20(
            "My Token",
            "MTK", 
            1000000 // 1 million tokens
        );
        
        console.log("SimpleERC20 deployed at address:", address(token));
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Total supply:", token.totalSupply());
        console.log("Deployer token balance:", token.balanceOf(deployer));
        console.log("Deployer remaining XRP balance:", deployer.balance);
        
        vm.stopBroadcast();
        
        console.log("Token deployed successfully!");
        console.log("Contract address:", address(token));
        console.log("Total supply: 1,000,000 MTK");
        console.log("All tokens minted to deployer:", deployer);
    }
}