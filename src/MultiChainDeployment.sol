// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/StdJson.sol";
import "forge-std/Vm.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "openzeppelin/utils/Strings.sol";

contract MultiChainDeployment is Script {
    using Strings for uint256;
    using stdJson for string;

    Vm public constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function readNetworkConfig(
        string memory network, // ".mainnet" or ".testnet"
        string memory inputPath // "/script/target/chainConfig.json"
    )
        internal
        view
        returns (
            string memory rpcUrl,
            uint256 gasLimit,
            string memory contractArgs,
            uint256 chainId,
            string memory explorerUrl,
            string memory nativeCurrency
        )
    {
        string memory jsonContent = vm.readFile(inputPath);
        string memory networkData = vm.parseJsonString(jsonContent, network);

        rpcUrl = vm.parseJsonString(networkData, ".rpcUrl");

        gasLimit = vm.parseJsonUint(networkData, ".gasLimit");

        contractArgs = vm.parseJsonString(networkData, ".contractArgs");

        chainId = vm.parseJsonUint(networkData, ".chainId");

        explorerUrl = vm.parseJsonString(networkData, ".explorerUrl");

        nativeCurrency = vm.parseJsonString(networkData, ".nativeCurrency");

        console2.log("Network:", network);
        console2.log("RPC URL:", rpcUrl);
        console2.log("Gas Limit:", gasLimit);
        console2.log("Contract Arguments:", contractArgs);
        console2.log("Chain ID:", chainId);
        console2.log("Explorer URL:", explorerUrl);
        console2.log("Native Currency:", nativeCurrency);
    }
}
