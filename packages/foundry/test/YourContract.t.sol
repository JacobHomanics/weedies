// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";

contract YourContractTest is Test {
    YourContract public yourContract;

    function setUp() public {
        yourContract = new YourContract(
            vm.addr(1),
            vm.addr(1),
            24420,
            24 hours
        );
    }

    function testMessageOnDeployment() public {
        // yourContract.mint{value: 0}();
        // me();
        // yourContract.mint{value: 0}();
        // me();
        // yourContract.mint{value: 0}();
        // me();
        // yourContract.mint{value: 0}();
        // me();
        // yourContract.mint{value: 0}();
        // me();
        // yourContract.mint{value: 0.1 ether}();
        // me();
    }

    function me() public view {
        // YourContract.MintingThreshold memory threshold = yourContract
        //     .getAcitveMintingThreshold();
        // console.log(threshold.minThreshold);
        // console.log(threshold.maxThreshold);
        // console.log(threshold.mintPrice);
    }

    function testSetNewMessage() public {}
}
