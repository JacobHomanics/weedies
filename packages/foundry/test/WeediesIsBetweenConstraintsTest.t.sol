// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Weedies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {BaseWeediesTest} from "./BaseWeedies.t.sol";

contract WeediesIsBetweenConstraintsTest is BaseWeediesTest {
    constructor() BaseWeediesTest(1, type(uint256).max, 0) {}

    function testIsWithinConstraints(uint256 timestamp) public {
        vm.assume(
            timestamp >= MINT_START_TIMESTAMP && timestamp <= MINT_END_TIMESTAMP
        );

        vm.warp(timestamp);
        assertEq(yourContract.isWithinConstraints(), true);
    }

    function testIsNotWithinConstraints(uint256 timestamp) public {
        vm.assume(
            timestamp < MINT_START_TIMESTAMP || timestamp > MINT_END_TIMESTAMP
        );

        vm.warp(timestamp);
        assertEq(yourContract.isWithinConstraints(), false);

        // vm.expectRevert(
        //     Weedies.Weedies__TheDealersNotAnsweringHisPhone.selector
        // );

        // yourContract.mint();
    }
}
