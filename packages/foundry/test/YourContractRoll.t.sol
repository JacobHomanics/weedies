// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract YourContractRollTest is Test {
    YourContract public yourContract;

    address mintRoyaltyRecipient = vm.addr(1);
    address USER = vm.addr(2);
    address ADMIN = vm.addr(3);

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
            ADMIN,
            mintRoyaltyRecipient,
            BASE_URI,
            s_maxTokenCount,
            MINT_START_TIMESTAMP,
            MINT_END_TIMESTAMP,
            thresholds
        );

        vm.prank(ADMIN);
        yourContract.setUpMintableTokenIds(s_maxTokenCount);
    }

    function testMintTimestamps() public view {
        assertEq(yourContract.getMintStartTimestamp(), MINT_START_TIMESTAMP);
        assertEq(yourContract.getMintEndTimestamp(), MINT_END_TIMESTAMP);
    }

    function testRollOneOut() public {
        vm.prank(USER);
        uint256 result = yourContract.rollOneUp();

        assertEq(
            yourContract.getRolledTokenURI(USER),
            string.concat(BASE_URI, Strings.toString(result))
        );
        assertEq(yourContract.getRolledTokenId(USER), result);
    }

    function testRerollOneOut() public {
        vm.prank(USER);
        uint256 result = yourContract.rollOneUp();

        assertEq(
            yourContract.getRolledTokenURI(USER),
            string.concat(BASE_URI, Strings.toString(result))
        );
        assertEq(yourContract.getRolledTokenId(USER), result);

        vm.prank(USER);
        uint256 result2 = yourContract.rollOneUp();

        assertEq(
            yourContract.getRolledTokenURI(USER),
            string.concat(BASE_URI, Strings.toString(result2))
        );
        assertEq(yourContract.getRolledTokenId(USER), result2);
    }

    function testRevertGenerateRandomNumber() public {
        vm.prank(USER);
        yourContract.rollOneUp();

        // console.log(yourContract.getMintsLeft());

        for (uint256 i = 0; i < s_maxTokenCount; i++) {
            vm.prank(USER);
            yourContract.rollOneUp();
            // vm.prank(USER);
            // yourContract.mint();
        }

        // console.log(yourContract.getMintsLeft());

        // vm.prank(USER);
        // vm.expectRevert(YourContract.Weedies__AllWeediesAreTwisted.selector);
        // yourContract.rollOneUp();
    }

    // function testMint() public {
    //     vm.prank(USER);
    //     uint256 result = yourContract.rollOneUp();
    //     vm.prank(USER);
    //     yourContract.mint();

    //     assertEq(yourContract.getMintCount(), 1);
    //     assertEq(
    //         yourContract.tokenURI(1),
    //         string.concat(BASE_URI, Strings.toString(result))
    //     );
    // }

    // function testRevertMintRepeatMint() public {
    //     vm.prank(USER);
    //     yourContract.rollOneUp();
    //     vm.prank(USER);
    //     yourContract.mint();

    //     vm.expectRevert(
    //         YourContract.Weedies__UserNotActivelyRollingAWeedie.selector
    //     );
    //     yourContract.mint();
    // }

    // function testRevertMintNeverRolled() public {
    //     vm.expectRevert(
    //         YourContract.Weedies__UserNotActivelyRollingAWeedie.selector
    //     );
    //     yourContract.mint();
    // }

    // function testRevertMintTheDealerIsNotAround(uint256 timestamp) public {
    //     vm.assume(
    //         timestamp < MINT_START_TIMESTAMP || timestamp > MINT_END_TIMESTAMP
    //     );

    //     vm.warp(timestamp);

    //     vm.prank(USER);
    //     yourContract.rollOneUp();

    //     vm.expectRevert(YourContract.Weedies__TheDealersNotAround.selector);

    //     vm.prank(USER);
    //     yourContract.mint();
    // }

    // function testWithdrawRewards(uint256 mintAmount) public {
    //     vm.deal(USER, mintAmount);

    //     vm.prank(USER);
    //     yourContract.rollOneUp();
    //     vm.prank(USER);

    //     yourContract.mint{value: mintAmount}();

    //     bool sent = yourContract.withdraw();
    //     assertEq(address(yourContract).balance, 0);
    //     assertEq(mintRoyaltyRecipient.balance, mintAmount);
    //     assertEq(sent, true);
    // }
}
