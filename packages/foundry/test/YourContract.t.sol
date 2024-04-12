// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract YourContractTest is Test {
    YourContract public yourContract;

    address mintRoyaltyRecipient = vm.addr(1);
    address USER = vm.addr(2);

    string BASE_URI =
        "https://nft.bueno.art/api/contract/0zJlzGVsEKj7cALqS-QMX/chain/1/metadata/";

    uint256 s_maxTokenCount = 24420;
    uint256 MINT_START_TIMESTAMP = 0;
    uint256 MINT_END_TIMESTAMP = 100;

    function setUp() public {
        YourContract.MintingThreshold[] memory thresholds =
            new YourContract.MintingThreshold[](1);
        thresholds[0] =
            YourContract.MintingThreshold(0, type(uint256).max, 0 ether);

        yourContract = new YourContract(
            mintRoyaltyRecipient,
            BASE_URI,
            s_maxTokenCount,
            MINT_START_TIMESTAMP,
            MINT_END_TIMESTAMP,
            thresholds
        );
    }

    function testMintTimestamps() public view {
        assertEq(yourContract.getMintStartTimestamp(), MINT_START_TIMESTAMP);
        assertEq(yourContract.getMintEndTimestamp(), MINT_END_TIMESTAMP);
    }

    function testMint() public {
        yourContract.mint();

        assertEq(yourContract.getMintCount(), 1);
        assertEq(
            yourContract.tokenURI(1),
            string.concat(BASE_URI, Strings.toString(1))
        );
    }

    function testRevertMintTheDealerIsNotAround(uint256 timestamp) public {
        vm.assume(
            timestamp < MINT_START_TIMESTAMP || timestamp > MINT_END_TIMESTAMP
        );

        vm.warp(timestamp);

        vm.expectRevert(
            YourContract.Weedies__TheDealersNotAnsweringHisPhone.selector
        );

        yourContract.mint();
    }

    function testRevertTheDealerIsAllOuttaTheWeed() public {
        for (uint256 j = 0; j < s_maxTokenCount; j++) {
            vm.prank(vm.addr(j + 1));
            yourContract.mint();
        }

        vm.expectRevert(
            YourContract.Weedies__TheDealersOutOfTheGoodStuff.selector
        );

        yourContract.mint();
    }

    function testRevertTooGreedy() public {
        yourContract.mint();

        vm.expectRevert(YourContract.Weedies__NowNowNotTooGreedy.selector);

        yourContract.mint();
    }

    function testWithdrawRewards(uint256 mintAmount) public {
        vm.deal(address(this), mintAmount);

        yourContract.mint{value: mintAmount}();

        bool sent = yourContract.withdraw();
        assertEq(address(yourContract).balance, 0);
        assertEq(mintRoyaltyRecipient.balance, mintAmount);
        assertEq(sent, true);
    }
}
