// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Weedies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {BaseWeediesTest} from "./BaseWeedies.t.sol";

contract WeediesMintTest is BaseWeediesTest {
    constructor() BaseWeediesTest(0, 100, 0) {}

    function testMint() public {
        yourContract.mint(USER, 1);

        assertEq(yourContract.getMintCount(), 2);
        assertEq(
            yourContract.tokenURI(2),
            string.concat(BASE_URI, Strings.toString(2))
        );
    }

    function testRevertMintTheDealerIsNotAround(uint256 timestamp) public {
        vm.assume(
            timestamp < MINT_START_TIMESTAMP || timestamp > MINT_END_TIMESTAMP
        );

        vm.warp(timestamp);

        vm.expectRevert(
            Weedies.Weedies__TheDealersNotAnsweringHisPhone.selector
        );

        yourContract.mint(USER, 1);
    }

    function testRevertTheDealerIsAllOuttaTheWeed() public {
        for (uint256 j = 0; j < s_maxTokenCount - 1; j++) {
            vm.prank(vm.addr(j + 1));
            yourContract.mint(vm.addr(j + 1), 1);
        }

        vm.expectRevert(Weedies.Weedies__TheDealersOutOfTheGoodStuff.selector);
        yourContract.mint(USER, 1);
    }

    function testRevertTheDealerIsGonnaBeOutOfWeed() public {
        for (uint256 j = 0; j < s_maxTokenCount - 5; j++) {
            vm.prank(vm.addr(j + 1));
            yourContract.mint(vm.addr(j + 1), 1);
        }

        vm.expectRevert(Weedies.Weedies__TheDealerDoesNotHaveThatMuch.selector);
        yourContract.mint(USER, 20);
    }

    function testRevertUserMaxedMintCount() public {
        vm.prank(USER);
        yourContract.mint(USER, 419);

        vm.expectRevert(Weedies.Weedies__DontHarshOurMellowDude.selector);

        vm.prank(USER);
        yourContract.mint(USER, 1);
    }
}
