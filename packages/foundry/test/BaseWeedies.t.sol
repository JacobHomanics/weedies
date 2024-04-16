// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Weedies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract BaseWeediesTest is Test {
    Weedies public yourContract;

    address mintRoyaltyRecipient = vm.addr(1);
    address USER = vm.addr(2);

    string BASE_URI =
        "https://nft.bueno.art/api/contract/0zJlzGVsEKj7cALqS-QMX/chain/1/metadata/";

    uint256 s_maxTokenCount = 24420;
    uint256 MINT_START_TIMESTAMP;
    uint256 MINT_END_TIMESTAMP;
    uint256 s_mintPrice;

    constructor(
        uint256 mintStartTimestamp,
        uint256 mintEndTimestamp,
        uint256 mintPrice
    ) {
        MINT_START_TIMESTAMP = mintStartTimestamp;
        MINT_END_TIMESTAMP = mintEndTimestamp;
        s_mintPrice = mintPrice;
    }

    function setUp() public {
        Weedies.MintingThreshold[] memory thresholds =
            new Weedies.MintingThreshold[](1);
        thresholds[0] =
            Weedies.MintingThreshold(0, type(uint256).max, s_mintPrice);

        address[] memory users = new address[](1);
        users[0] = USER;

        yourContract = new Weedies(
            mintRoyaltyRecipient,
            mintRoyaltyRecipient,
            BASE_URI,
            s_maxTokenCount,
            MINT_START_TIMESTAMP,
            MINT_END_TIMESTAMP,
            thresholds,
            420,
            users
        );
    }

    function testMintTimestamps() public view {
        assertEq(yourContract.getMintStartTimestamp(), MINT_START_TIMESTAMP);
        assertEq(yourContract.getMintEndTimestamp(), MINT_END_TIMESTAMP);
    }
}
