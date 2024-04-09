// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract YourContractBaseRandomness is Test {
    YourContract public yourContract;

    address mintRoyaltyRecipient = vm.addr(1);
    address USER = vm.addr(2);

    string BASE_URI =
        "https://nft.bueno.art/api/contract/0zJlzGVsEKj7cALqS-QMX/chain/1/metadata/";

    uint256 MAX_TOKEN_COUNT_24420 = 24420;
    uint256 MAX_TOKEN_COUNT_5 = 5;

    uint256 s_maxTokenCount;

    uint256[] answerSheetUnfiltered = new uint256[](5);
    uint256[] answerSheetUnfilteredWithIndexAccomodation = new uint256[](5);
    uint256[] answerSheetFiltered = new uint256[](5);
    uint256[] answerSheetFilteredNoWrite = new uint256[](5);

    uint256[] randomBlocks = new uint256[](5);

    function baseSetUp(uint256 maxTokenCount) public {
        randomBlocks[0] = 1;
        randomBlocks[1] = 15;
        randomBlocks[2] = 200;
        randomBlocks[3] = 1234;
        randomBlocks[4] = 13218;

        YourContract.MintingThreshold[] memory thresholds =
            new YourContract.MintingThreshold[](2);
        thresholds[0] = YourContract.MintingThreshold(0, 1000, 0 ether);
        thresholds[1] = YourContract.MintingThreshold(
            1000, type(uint256).max, 0.0006942 ether
        );
        yourContract = new YourContract(
            mintRoyaltyRecipient, BASE_URI, maxTokenCount, 0, 0, thresholds
        );
    }

    function testGenerateRandomNumber() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);
            uint256 number = yourContract.generateRandomNumber(s_maxTokenCount);

            assertEq(number, answerSheetUnfiltered[i]);
        }
    }

    function testGenerateRandomNumberWithIndexAccomodation() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);
            uint256 number = yourContract
                .generateRandomNumberWithIndexAccomodation(s_maxTokenCount);

            assertEq(number, answerSheetUnfilteredWithIndexAccomodation[i]);
        }
    }

    function testGenerateRandomNumberWithFilterNoWrite() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);
            (, uint256 number) = yourContract
                .generateRandomNumberWithFilterNoWrite(s_maxTokenCount);

            assertEq(number, answerSheetFilteredNoWrite[i]);
        }
    }

    function testGenerateRandomNumberWithFilter() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);
            uint256 number =
                yourContract.generateRandomNumberWithFilter(s_maxTokenCount);

            assertEq(number, answerSheetFiltered[i]);
        }
    }

    function testRevertGenerateRandomNumber() public {
        for (uint256 i = 0; i < s_maxTokenCount; i++) {
            vm.prank(USER);
            yourContract.generateRandomNumberWithFilter(s_maxTokenCount);
        }

        vm.prank(USER);
        vm.expectRevert(YourContract.Weedies__AllWeediesAreTwisted.selector);
        yourContract.generateRandomNumberWithFilter(s_maxTokenCount);
    }
}
