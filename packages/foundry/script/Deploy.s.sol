//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/YourContract.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }

        // YourContract.MintingThreshold[] memory thresholds =
        //     new YourContract.MintingThreshold[](2);
        // thresholds[0] = YourContract.MintingThreshold(0, 1000, 0 ether);
        // thresholds[1] = YourContract.MintingThreshold(
        //     1000, type(uint256).max, 0.0006942 ether
        // );

        // vm.startBroadcast(deployerPrivateKey);
        // YourContract yourContract = new YourContract(
        //     0x2F15D4A66D22ecC6967928b6A76Ab06897b05676, //0x4161f8A8DfF60aEdB63baFb7d5843b0988393eC9,
        //     0x2F15D4A66D22ecC6967928b6A76Ab06897b05676, //0x4161f8A8DfF60aEdB63baFb7d5843b0988393eC9,
        //     24420,
        //     24 hours,
        //     thresholds
        // );
        // console.logString(
        //     string.concat(
        //         "YourContract deployed at: ", vm.toString(address(yourContract))
        //     )
        // );
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
