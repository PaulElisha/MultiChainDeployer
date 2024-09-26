// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/MultiChainDeployment.sol";
import "../src/MyContract.sol";

contract MultiChainDeploymentScript is Script {
    MultiChainDeployment multiChainDeployment;
    MyContract myContract;

    function run() public {
        multiChainDeployment = new MultiChainDeployment();

        string[] memory networks = new string[](3);
        networks[0] = "mainnet";
        networks[1] = "rinkeby";
        networks[2] = "polygon";

        for (uint256 i = 0; i < networks.length; i++) {
            string memory network = networks[i];
            (
                string memory rpcUrl,
                uint256 gasLimit,
                address tokenAddress
            ) = multiChainDeployment.readNetworkConfig(network);

            vm.setRpcUrl(rpcUrl);

            vm.startBroadcast();
            myContract = new MyContract(tokenAddress);
            vm.stopBroadcast();

            console.log(
                "Deployed MyContract on",
                network,
                "at address:",
                address(myContract)
            );
        }
    }
}
