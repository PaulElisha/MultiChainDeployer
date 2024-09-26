// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/StdJson.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "openzeppelin/utils/Strings.sol";

contract MultiChainDeployment is Script {
    using Strings for uint256;
    using stdJson for string;

    function readNetworkConfig(
        string memory network
    )
        public
        view
        returns (
            string memory rpcUrl,
            uint256 gasLimit,
            address tokenAddress,
            uint256 chainId,
            string memory explorerUrl,
            string memory nativeCurrency
        )
    {
        string memory jsonContent = vm.readFile("networks.json");

        rpcUrl = jsonContent.parseJson(
            string(abi.encodePacked(".", network, ".rpcUrl"))
        );
        gasLimit = jsonContent.parseJson(
            string(abi.encodePacked(".", network, ".gasLimit"))
        );
        tokenAddress = jsonContent.parseJson(
            string(abi.encodePacked(".", network, ".tokenAddress"))
        );
        chainId = jsonContent.parseJson(
            string(abi.encodePacked(".", network, ".chainId"))
        );
        explorerUrl = jsonContent.parseJson(
            string(abi.encodePacked(".", network, ".explorerUrl"))
        );
        nativeCurrency = jsonContent.parseJson(
            string(abi.encodePacked(".", network, ".nativeCurrency"))
        );

        console2.log("Network:", network);
        console2.log("RPC URL:", rpcUrl);
        console2.log("Gas Limit:", gasLimit);
        console2.log("Token Address:", tokenAddress);
        console2.log("Chain ID:", chainId);
        console2.log("Explorer URL:", explorerUrl);
        console2.log("Native Currency:", nativeCurrency);
    }

    function writeNetworkConfig(
        string memory network,
        string memory rpcUrl,
        uint256 gasLimit,
        address tokenAddress,
        uint256 chainId,
        string memory explorerUrl,
        string memory nativeCurrency
    ) public {
        string memory jsonContent = vm.readFile("networks.json");

        string memory newEntry = string(
            abi.encodePacked(
                '{"',
                network,
                '": {',
                '"rpcUrl": "',
                rpcUrl,
                '", ',
                '"gasLimit": ',
                gasLimit.toString(),
                ", ",
                '"tokenAddress": "',
                tokenAddress.toHexString(),
                '", ',
                '"chainId": ',
                chainId.toString(),
                ", ",
                '"explorerUrl": "',
                explorerUrl,
                '", ',
                '"nativeCurrency": "',
                nativeCurrency,
                '"',
                "}}"
            )
        );

        if (jsonContent.contains(network)) {
            jsonContent = jsonContent.replace(
                string(abi.encodePacked('"', network, '": {')),
                newEntry
            );
        } else {
            jsonContent = string(abi.encodePacked(jsonContent, ",", newEntry));
        }

        vm.writeFile("networks.json", jsonContent);

        console2.log("Updated configuration for:", network);
    }
}
