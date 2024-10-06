// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/MultiChainDeployment.sol";
import "../src/MyContract.sol";

contract Interactions is Script {
    MyContract myContract;

    Vm public constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() public {
        string[] memory networks = new string[](3);
        networks[0] = "mainnet";
        networks[1] = "rinkeby";
        networks[2] = "polygon";

        for (uint256 i = 0; i < networks.length; i++) {
            string memory network = networks[i];
            (
                string memory rpcUrl,
                uint256 gasLimit,
                string memory contractArgs,
                uint256 chainId,
                string memory explorerUrl,
                string memory nativeCurrency
            ) = MultiChainDeployment.readNetworkConfig(network);

            vm.startBroadcast();
            myContract = new MyContract(contractArgs);
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
