# XRPL EVM Sidechain Foundry Quickstart

This guide will walk you through deploying an ERC20 token on the XRPL EVM sidechain testnet using Foundry.

## Prerequisites

### Install Foundry

If you don't have Foundry installed yet:

1. Visit [https://getfoundry.sh](https://getfoundry.sh)
2. Run the installation command:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   ```
3. Restart your terminal and run:
   ```bash
   foundryup
   ```
4. Verify installation:
   ```bash
   forge --version
   ```

### Other Requirements

- An account with XRP for gas fees
- Basic knowledge of Solidity and command line

## Quick Start (Clone This Repo)

If you want to use this existing project instead of starting from scratch:

```bash
# Clone the repository
git clone <repo-url>
cd xrpl-evm-quickstart

# Install dependencies
forge install
forge install OpenZeppelin/openzeppelin-contracts

# Edit .env with your configuration
nano .env  # or use your preferred editor

# Build the project
forge build

# Run tests
forge test

# Deploy to XRPL EVM Sidechain Testnet
forge script script/Deploy.s.sol \
  --rpc-url $RPC_URL \
  --broadcast \
  --legacy
```

## Setup From Scratch

### 1. Initialize Foundry Project

```bash
forge init xrpl-evm-quickstart
cd xrpl-evm-quickstart
```

### 2. Install OpenZeppelin Contracts

```bash
forge install OpenZeppelin/openzeppelin-contracts
```

### 3. Update foundry.toml

Replace your `foundry.toml` with:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
fs_permissions = [{ access = "read", path = "./"}]
remappings = ["@openzeppelin/=lib/openzeppelin-contracts/"]
solc = "0.8.20"

[rpc_endpoints]
xrpl-evm-testnet = "https://rpc.testnet.xrplevm.org"
```

### 4. Environment Configuration

Create a `.env` file in your project root:

```bash
# XRPL EVM Sidechain TESTNET RPC URL
RPC_URL=https://rpc.testnet.xrplevm.org

# Your private key (DO NOT COMMIT THIS TO VERSION CONTROL)
# Use the same format as your working script: 0x prefix for bytes32
PRIVATE_KEY=1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
```

**⚠️ Security Warning**: Never commit your `.env` file or private keys to version control. Add `.env` to your `.gitignore` file.

### 5. Load Environment Variables

```bash
source .env
```

### 6. Verify Environment Variables

```bash
# Check that variables are loaded
echo $RPC_URL
echo $PRIVATE_KEY  # Should show your private key (be careful in shared terminals!)
```

## Smart Contract

The `SimpleERC20.sol` contract is a basic ERC20 token with minting functionality, inheriting from OpenZeppelin's battle-tested contracts.

**Key Features:**
- Standard ERC20 functionality (transfer, approve, etc.)
- Owner-only minting capability
- Initial supply minted to deployer

## Deployment Script

The `Deploy.s.sol` script follows the proven pattern used for XRPL EVM sidechain deployments:

## Deployment

### 1. Compile Contracts

```bash
forge build
```

### 2. Deploy to XRPL EVM Sidechain

**Method 1: Using environment variables (recommended)**
```bash
# Make sure .env is loaded first
source .env

# Deploy using environment variables from the script
forge script script/Deploy.s.sol \
  --rpc-url $RPC_URL \
  --broadcast \
  --legacy \
```

**Method 2: Explicit private key parameter**
```bash
# Load environment variables
source .env

# Deploy with explicit private key parameter
forge script script/Deploy.s.sol \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --legacy \
  --resume
```

### 3. Deployment Output

After successful deployment, you'll see:
- Contract address
- Total supply
- Deployer's token balance
- Transaction hash

## Interacting with Your Contract

### Using Cast (Foundry's CLI tool)

Check token balance:
```bash
cast call <CONTRACT_ADDRESS> "balanceOf(address)" <WALLET_ADDRESS> --rpc-url $RPC_URL
```

Check total supply:
```bash
cast call <CONTRACT_ADDRESS> "totalSupply()" --rpc-url $RPC_URL
```

Transfer tokens:
```bash
cast send <CONTRACT_ADDRESS> "transfer(address,uint256)" <RECIPIENT_ADDRESS> <AMOUNT> --private-key $PRIVATE_KEY --rpc-url $RPC_URL
```

Mint new tokens (owner only):
```bash
cast send <CONTRACT_ADDRESS> "mint(address,uint256)" <RECIPIENT_ADDRESS> <AMOUNT> --private-key $PRIVATE_KEY --rpc-url $RPC_URL
```

## Testing

### Write Tests

Create `test/SimpleERC20.t.sol`:

```solidity
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

    function testInitialSupply() public {
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
```

### Run Tests

```bash
forge test
```

### Run Tests with Verbosity

```bash
forge test -vv
```

## Common Issues & Solutions

### Gas Issues
- Ensure you have sufficient XRP for gas fees
- Gas prices may vary; monitor network congestion

### RPC Connection Issues
- Verify the RPC URL is correct and accessible
- Check your internet connection

### Private Key Issues
- Ensure your private key is correctly formatted (with or without 0x prefix)
- Verify the associated address has sufficient funds

### Compilation Issues
- Check Solidity version compatibility
- Ensure all dependencies are properly installed

## Security Best Practices

1. **Never expose private keys**: Use hardware wallets or secure key management for production
2. **Test thoroughly**: Always test on testnets before mainnet deployment
3. **Audit contracts**: Consider professional audits for production contracts
4. **Use established libraries**: Leverage OpenZeppelin for standard functionality
5. **Monitor deployments**: Keep track of your deployed contracts and their interactions

## Additional Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [XRPL EVM Sidechain Documentation](https://docs.xrplevm.org/)
- [Solidity Documentation](https://docs.soliditylang.org/)

## Getting XRP for Gas Fees

Before deploying, you need XRP in your wallet to pay for gas fees. Here's how to get them:

### XRPL Testnet Faucet (Recommended for Testing)
1. Visit the [XRP Faucet - XRPL EVM Sidechain Testnet](https://xrpl-evm-xrp-faucet.vercel.app/)
2. Enter your wallet address to receive free testnet XRP
3. Wait for the transaction to confirm

### Alternative: XRPL EVM Testnet Faucet
- Alternatively you can use the [Squid router bridge](https://testnet.xrpl.squidrouter.com/) to bridge some test XRP from XRPL to the XRPL EVM Sidechain.

### Check Your Balance
```bash
# Check your wallet balance on testnet
cast balance <YOUR_WALLET_ADDRESS> --rpc-url https://rpc.testnet.xrplevm.org
```

## Troubleshooting

### Common Deployment Errors

#### Troubleshooting Failed Deployments

If `cast call` returns `0x`, the contract deployment likely failed. Debug with:

```bash
# 1. Check if contract exists
cast code <CONTRACT_ADDRESS> --rpc-url $RPC_URL

# 2. Verify your wallet balance
cast balance $(cast wallet address --private-key $PRIVATE_KEY) --rpc-url $RPC_URL

# 3. Check broadcast logs for transaction details
cat broadcast/Deploy.s.sol/1440002/run-latest.json

# 4. Redeploy with maximum verbosity
forge script script/Deploy.s.sol:Deploy --rpc-url xrpl-evm-sidechain --broadcast --skip-simulation -vvvv
```

**Happy deploying! 🚀**