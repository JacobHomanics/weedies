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

    uint256 s_maxTokenCount = 24420;
    uint256 MINT_START_TIMESTAMP = 0;
    uint256 MINT_END_TIMESTAMP = 100;

    function setUp() public {
        YourContract.MintingThreshold[] memory thresholds =
            new YourContract.MintingThreshold[](2);
        thresholds[0] = YourContract.MintingThreshold(0, 1000, 0 ether);
        thresholds[1] = YourContract.MintingThreshold(
            1000, type(uint256).max, 0.0006942 ether
        );
        yourContract = new YourContract(
            admin,
            admin,
            24 hours,
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

    function testRollOneOut(uint256 blockNumber) public {
        vm.assume(blockNumber > 0);

        vm.roll(blockNumber);

        vm.prank(USER);
        uint256 result = yourContract.rollOneUp();

        assertEq(
            yourContract.getRolledTokenURI(USER),
            string.concat(BASE_URI, Strings.toString(result))
        );
        assertEq(yourContract.getRolledTokenId(USER), result);
    }

    function testRerollOneOut(uint256 blockNumber) public {
        vm.assume(blockNumber > 0);

        vm.roll(blockNumber);

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

    function testMint() public {
        vm.prank(USER);
        uint256 result = yourContract.rollOneUp();
        vm.prank(USER);
        yourContract.mint();

        assertEq(yourContract.getMintCount(), 1);
        assertEq(
            yourContract.tokenURI(1),
            string.concat(BASE_URI, Strings.toString(result))
        );
    }

    function testRevertMintRepeatMint() public {
        vm.prank(USER);
        yourContract.rollOneUp();
        vm.prank(USER);
        yourContract.mint();

        vm.expectRevert(
            YourContract.Weedies__UserNotActivelyRollingAWeedie.selector
        );
        yourContract.mint();
    }

    function testRevertMintNeverRolled() public {
        vm.expectRevert(
            YourContract.Weedies__UserNotActivelyRollingAWeedie.selector
        );
        yourContract.mint();
    }

    function testRevertMintTheDealerIsNotAround(uint256 timestamp) public {
        vm.warp(timestamp);

        vm.assume(
            timestamp < MINT_START_TIMESTAMP || timestamp > MINT_END_TIMESTAMP
        );

        vm.prank(USER);
        yourContract.rollOneUp();

        vm.expectRevert(YourContract.Weedies__TheDealersNotAround.selector);

        vm.prank(USER);
        yourContract.mint();
    }

    function testWithdrawRewards(uint256 mintAmount) public {
        vm.prank(USER);
        yourContract.rollOneUp();
        vm.prank(USER);

        yourContract.mint{value: mintAmount}();

        bool sent = yourContract.withdraw();
        assertEq(address(yourContract).balance, 0);
        assertEq(admin.balance, mintAmount);
        assertEq(sent, true);
    }
}
