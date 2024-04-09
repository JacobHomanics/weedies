// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./YourContractBaseRandomness.t.sol";

contract YourContract24420SheetRandomness is YourContractBaseRandomness {
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

    function setUp() public {
        setUp24420AnswerSheets();
        baseSetUp(24420);
    }
}
