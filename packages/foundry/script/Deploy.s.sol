//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/Weedies.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function getSetup()
        public
        returns (
            uint256 maxMintCount,
            uint256 mintStartTimestamp,
            uint256 mintEndTimestamp,
            Weedies.MintingThreshold[] memory thresholds,
            address[] memory initialMintRecipients
        )
    {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }

        if (chainId == 31337) {
            maxMintCount = 24420;

            mintStartTimestamp = (vm.unixTime() / 1000) + 20 seconds;
            mintEndTimestamp = 0; //(vm.unixTime() / 1000) + 1 days;

            thresholds = new Weedies.MintingThreshold[](1);
            thresholds[0] =
                Weedies.MintingThreshold(0, type(uint256).max, 0.0006942 ether);

            initialMintRecipients = new address[](3);
            initialMintRecipients[0] =
                0xc689c800a7121b186208ea3b182fAb2671B337E7;
            initialMintRecipients[1] =
                0x136883B2841D7DE5C13EcEE65788FDE191Da5F20;
            initialMintRecipients[2] =
                0xC2aAa18BAD26C6E78b2Ae897911e179F00C79725;
        } else if (chainId == 11155111) {
            maxMintCount = 24420;

            mintStartTimestamp = 1713589200;
            mintEndTimestamp = 0;

            thresholds = new Weedies.MintingThreshold[](1);
            thresholds[0] =
                Weedies.MintingThreshold(0, type(uint256).max, 0.0006942 ether);

            initialMintRecipients = new address[](3);
            initialMintRecipients[0] =
                0xc689c800a7121b186208ea3b182fAb2671B337E7;
            initialMintRecipients[1] =
                0x136883B2841D7DE5C13EcEE65788FDE191Da5F20;
            initialMintRecipients[2] =
                0xC2aAa18BAD26C6E78b2Ae897911e179F00C79725;
        } else if (chainId == 8453) {
            maxMintCount = 24420;

            mintStartTimestamp = 1713589200;
            mintEndTimestamp = 0;

            thresholds = new Weedies.MintingThreshold[](1);
            thresholds[0] =
                Weedies.MintingThreshold(0, type(uint256).max, 0.0006942 ether);

            initialMintRecipients = new address[](3);
            initialMintRecipients[0] =
                0xc689c800a7121b186208ea3b182fAb2671B337E7;
            initialMintRecipients[1] =
                0x136883B2841D7DE5C13EcEE65788FDE191Da5F20;
            initialMintRecipients[2] =
                0xC2aAa18BAD26C6E78b2Ae897911e179F00C79725;
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
            Weedies.MintingThreshold[] memory thresholds,
            address[] memory initialMintRecipients
        ) = getSetup();

        vm.startBroadcast(deployerPrivateKey);
        Weedies yourContract = new Weedies(
            0x0F4D8B0aD335550cD06ec13a2712EdCa59E8F4Ac, // Weedies Multi-sig
            0x3d22d4304078Ac166608Aca8f3d42E0447954c34, // 0xSplit
            "ipfs://bafybeicpvzgkhgyhwggrtctzvztuk2mftmt56xogv6pi7mx2v42go35ltu/",
            maxMintCount,
            mintStartTimestamp,
            mintEndTimestamp,
            thresholds,
            420,
            initialMintRecipients
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
