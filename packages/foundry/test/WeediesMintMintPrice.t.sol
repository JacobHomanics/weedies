// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Weedies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {BaseWeediesTest} from "./BaseWeedies.t.sol";

contract WeediesMintMintPriceTest is BaseWeediesTest {
    constructor() BaseWeediesTest(0, 100, 0.0006942 ether) {}

    function testRevertMintShortedTheDealer(uint256 amount) public {
        vm.assume(amount < s_mintPrice);

        vm.prank(USER);
        vm.expectRevert(Weedies.Weedies__YouShortedTheDealer.selector);
        yourContract.mint();
    }
}
