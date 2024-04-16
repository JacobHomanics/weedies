// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Weedies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {BaseWeediesTest} from "./BaseWeedies.t.sol";

contract WeediesWithdraw is BaseWeediesTest {
    constructor() BaseWeediesTest(0, 100, 0) {}

    function testWithdrawRewards(uint256 mintAmount) public {
        vm.deal(address(this), mintAmount);

        yourContract.mint{value: mintAmount}();

        bool sent = yourContract.withdraw();
        assertEq(address(yourContract).balance, 0);
        assertEq(mintRoyaltyRecipient.balance, mintAmount);
        assertEq(sent, true);
    }
}
