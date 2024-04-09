// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract YourContractTest is Test {
    YourContract public yourContract;

    address admin = vm.addr(1);
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

    function setUp24420AnswerSheets() public {
        s_maxTokenCount = MAX_TOKEN_COUNT_24420;

        answerSheetUnfiltered[0] = 22901;
        answerSheetUnfiltered[1] = 22920;
        answerSheetUnfiltered[2] = 1572;
        answerSheetUnfiltered[3] = 12509;
        answerSheetUnfiltered[4] = 18204;

        answerSheetUnfilteredWithIndexAccomodation[0] = 22902;
        answerSheetUnfilteredWithIndexAccomodation[1] = 22921;
        answerSheetUnfilteredWithIndexAccomodation[2] = 1573;
        answerSheetUnfilteredWithIndexAccomodation[3] = 12510;
        answerSheetUnfilteredWithIndexAccomodation[4] = 18205;

        answerSheetFiltered[0] = 22902;
        answerSheetFiltered[1] = 22921;
        answerSheetFiltered[2] = 1573;
        answerSheetFiltered[3] = 12510;
        answerSheetFiltered[4] = 18205;

        answerSheetFilteredNoWrite[0] = 22902;
        answerSheetFilteredNoWrite[1] = 22921;
        answerSheetFilteredNoWrite[2] = 1573;
        answerSheetFilteredNoWrite[3] = 12510;
        answerSheetFilteredNoWrite[4] = 18205;
    }

    function setUp5AnswerSheets() public {
        s_maxTokenCount = MAX_TOKEN_COUNT_5;

        answerSheetUnfiltered[0] = 1;
        answerSheetUnfiltered[1] = 0;
        answerSheetUnfiltered[2] = 2;
        answerSheetUnfiltered[3] = 4;
        answerSheetUnfiltered[4] = 4;

        answerSheetUnfilteredWithIndexAccomodation[0] = 2;
        answerSheetUnfilteredWithIndexAccomodation[1] = 1;
        answerSheetUnfilteredWithIndexAccomodation[2] = 3;
        answerSheetUnfilteredWithIndexAccomodation[3] = 5;
        answerSheetUnfilteredWithIndexAccomodation[4] = 5;

        answerSheetFiltered[0] = 2;
        answerSheetFiltered[1] = 1;
        answerSheetFiltered[2] = 3;
        answerSheetFiltered[3] = 4;
        answerSheetFiltered[4] = 5;

        answerSheetFilteredNoWrite[0] = 2;
        answerSheetFilteredNoWrite[1] = 1;
        answerSheetFilteredNoWrite[2] = 3;
        answerSheetFilteredNoWrite[3] = 5;
        answerSheetFilteredNoWrite[4] = 5;
    }

    function setUp() public {
        setUp5AnswerSheets();

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
            admin, admin, 24420, 24 hours, BASE_URI, s_maxTokenCount, thresholds
        );
    }

    // function testStartMint() public {
    //     vm.prank(admin);
    //     yourContract.startMint();

    //     // assertEq(yourContract.getIsMintStarted(), true);
    // }

    function testGenerateRandomNumberSheets() public {
        setUp24420AnswerSheets();
        generateAndCheckRandomNumber();
        setUp5AnswerSheets();
        generateAndCheckRandomNumber();
    }

    function generateAndCheckRandomNumber() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);

            uint256 number = yourContract.generateRandomNumber(s_maxTokenCount);

            assertEq(number, answerSheetUnfiltered[i]);
        }
    }

    // function testGenerateRandomNumber() public {
    //     for (uint256 i = 0; i < randomBlocks.length; i++) {
    //         vm.roll(randomBlocks[i]);

    //         vm.prank(USER);

    //         uint256 number = yourContract.generateRandomNumber(s_maxTokenCount);

    //         assertEq(number, answerSheetUnfiltered[i]);
    //     }
    // }

    function testGenerateRandomNumberWithIndexAccomodationUsingSheets()
        public
    {}

    function testGenerateRandomNumberWithIndexAccomodation() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);

            uint256 number = yourContract
                .generateRandomNumberWithIndexAccomodation(s_maxTokenCount);

            console.log(number);

            assertEq(number, answerSheetUnfilteredWithIndexAccomodation[i]);
        }
    }

    function testGenerateRandomNumberWithFilterNoWrite() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);
            (, uint256 number) = yourContract
                .generateRandomNumberWithFilterNoWrite(s_maxTokenCount);

            console.log(number);

            assertEq(number, answerSheetFilteredNoWrite[i]);
        }
    }

    function testGenerateRandomNumberWithFilter() public {
        for (uint256 i = 0; i < randomBlocks.length; i++) {
            vm.roll(randomBlocks[i]);

            vm.prank(USER);
            uint256 number =
                yourContract.generateRandomNumberWithFilter(s_maxTokenCount);

            console.log(number);

            assertEq(number, answerSheetFiltered[i]);
        }
    }

    // function testRevertGenerateRandomNumber() public {
    //     for (uint256 i = 0; i < randomBlocks.length; i++) {
    //         // vm.prank(USER);
    //         // yourContract.generateFilteredRandomNumber(s_maxTokenCount);
    //     }

    //     // vm.prank(USER);
    //     // vm.expectRevert(YourContract.Weedies__AllWeediesAreTwisted.selector);
    //     // yourContract.generateFilteredRandomNumber(s_maxTokenCount);
    // }

    // function testRollOneUp() public {
    //     for (uint256 i = 0; i < randomBlocks.length; i++) {
    //         vm.roll(randomBlocks[i]);

    //         vm.prank(USER);
    //         yourContract.rollOneUp();
    //         assertEq(
    //             yourContract.getRolledTokenURI(USER),
    //             string.concat(BASE_URI, Strings.toString(answerSheet[i]))
    //         );
    //     }
    // }

    // function testMessageOnDeployment() public {
    //     vm.prank(vm.addr(1));
    //     yourContract.startMint();

    //     vm.deal(vm.addr(1), 100 ether);
    //     yourContract.mint{value: 1 ether}();

    //     vm.warp(120010000);

    //     for (uint256 i = 1; i < 100; i++) {
    //         vm.roll(i);
    //         console.log(yourContract.generateRandomNumber(5));
    //     }

    //     // yourContract.mint{value: 0}();
    //     // me();
    //     // yourContract.mint{value: 0}();
    //     // me();
    //     // yourContract.mint{value: 0}();
    //     // me();
    //     // yourContract.mint{value: 0}();
    //     // me();
    //     // yourContract.mint{value: 0}();
    //     // me();
    //     // yourContract.mint{value: 0.1 ether}();
    //     // me();
    // }

    // function me() public view {
    //     // YourContract.MintingThreshold memory threshold = yourContract
    //     //     .getAcitveMintingThreshold();
    //     // console.log(threshold.minThreshold);
    //     // console.log(threshold.maxThreshold);
    //     // console.log(threshold.mintPrice);
    // }

    function testSetNewMessage() public {}
}
