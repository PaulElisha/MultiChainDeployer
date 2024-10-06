// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MultiChainDeployment.sol";
import "../script/Interactions.s.sol";
import "../src/chainConfig.json";

contract MultiChainDeploymentConfiguratorTest is Test {
    MultiChainDeployment multichainDeploy;

    function setUp() public {
        MultiChainDeploymentScript multichainDeployment = new MultiChainDeployScript();
        multichainDeploy = multichainDeployment.run();
    }

    function testReadNetworkConfig() public {
        (
            string memory rpcUrl,
            uint256 gasLimit,
            address tokenAddress
        ) = multichainDeploy.readNetworkConfig("chainConfig.json");

        assertEq(rpcUrl, "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID");
        assertEq(gasLimit, 3000000);
    }
}
