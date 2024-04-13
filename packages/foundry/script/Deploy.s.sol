//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/YourContract.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function getSetup()
        public
        returns (
            uint256 maxMintCount,
            uint256 mintStartTimestamp,
            uint256 mintEndTimestamp,
            YourContract.MintingThreshold[] memory thresholds
        )
    {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }

        if (chainId == 31337) {
            maxMintCount = 1000;

            mintStartTimestamp = (vm.unixTime() / 1000);
            mintEndTimestamp = (vm.unixTime() / 1000) + 1 days;

            thresholds = new YourContract.MintingThreshold[](1);
            thresholds[0] = YourContract.MintingThreshold(
                0, type(uint256).max, 0.0006942 ether
            );
        } else if (chainId == 11155111) {
            maxMintCount = 100;

            mintStartTimestamp = (vm.unixTime() / 1000);
            mintEndTimestamp = (vm.unixTime() / 1000) + 1 days;

            thresholds = new YourContract.MintingThreshold[](1);
            thresholds[0] = YourContract.MintingThreshold(
                0, type(uint256).max, 0.0006942 ether
            );
        } else if (chainId == 8453) {
            maxMintCount = 24420;

            mintStartTimestamp = 1713589200;
            mintEndTimestamp = 1713675600;

            thresholds = new YourContract.MintingThreshold[](1);
            thresholds[0] = YourContract.MintingThreshold(
                0, type(uint256).max, 0.0006942 ether
            );
        }
    }

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }

        (
            uint256 maxMintCount,
            uint256 mintStartTimestamp,
            uint256 mintEndTimestamp,
            YourContract.MintingThreshold[] memory thresholds
        ) = getSetup();

        vm.startBroadcast(deployerPrivateKey);
        YourContract yourContract = new YourContract(
            0x2F15D4A66D22ecC6967928b6A76Ab06897b05676,
            "https://nft.bueno.art/api/contract/0zJlzGVsEKj7cALqS-QMX/chain/1/metadata/",
            maxMintCount,
            mintStartTimestamp,
            mintEndTimestamp,
            thresholds
        );

        console.logString(
            string.concat(
                "YourContract deployed at: ", vm.toString(address(yourContract))
            )
        );

        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
