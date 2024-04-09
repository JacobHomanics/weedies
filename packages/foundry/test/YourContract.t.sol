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

    function setUp() public {
        YourContract.MintingThreshold[] memory thresholds =
            new YourContract.MintingThreshold[](2);
        thresholds[0] = YourContract.MintingThreshold(0, 1000, 0 ether);
        thresholds[1] = YourContract.MintingThreshold(
            1000, type(uint256).max, 0.0006942 ether
        );
        yourContract = new YourContract(
            admin, admin, 24 hours, BASE_URI, s_maxTokenCount, thresholds
        );
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
}
