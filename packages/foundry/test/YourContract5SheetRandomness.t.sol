// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./YourContractBaseRandomness.t.sol";

contract YourContract5SheetRandomness is YourContractBaseRandomness {
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
        baseSetUp(5);
    }
}
