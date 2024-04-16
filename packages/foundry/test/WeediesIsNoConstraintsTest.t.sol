// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Weedies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {BaseWeediesTest} from "./BaseWeedies.t.sol";

contract WeediesIsNoConstraintsTest is BaseWeediesTest {
    constructor() BaseWeediesTest(0, 0, 0) {}

    function testIsWithinConstraints(uint256 timestamp) public {
        vm.warp(timestamp);
        assertEq(yourContract.isWithinConstraints(), true);
    }
}
