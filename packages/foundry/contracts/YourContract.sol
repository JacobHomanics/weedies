//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "forge-std/Test.sol";

contract YourContract is ERC721 {
    error Weedies__YouShortedTheDealer();
    error Weedies__TheDealersNotAnsweringHisPhone();
    error Weedies__YouGottaHitUpTheWeedman();
    error Weedies__TheDealersOutOfTheGoodStuff();

    struct MintingThreshold {
        uint256 minThreshold;
        uint256 maxThreshold;
        uint256 mintPrice;
    }

    event Minted(address user, uint256 tokenId);

    address immutable s_mintRoyaltyRecipient;
    uint256 immutable s_maxTokenCount;
    uint256 immutable s_mintStartTimestamp;
    uint256 immutable s_mintEndTimestamp;
    MintingThreshold[] s_mintingThresholds;

    uint256 s_mintCount;
    string s_baseURI;

    constructor(
        address mintRoyaltyRecipient,
        string memory baseURI,
        uint256 maxTokenCount,
        uint256 mintStartTimestamp,
        uint256 mintEndTimestamp,
        MintingThreshold[] memory mintingThresholds
    ) ERC721("Weedies", "W") {
        s_mintRoyaltyRecipient = mintRoyaltyRecipient;
        s_baseURI = baseURI;
        s_maxTokenCount = maxTokenCount;
        s_mintStartTimestamp = mintStartTimestamp;
        s_mintEndTimestamp = mintEndTimestamp;

        for (uint256 i = 0; i < mintingThresholds.length; i++) {
            s_mintingThresholds.push(mintingThresholds[i]);
        }
    }

    function mint() external payable {
        if (!isTimestampInWindow()) {
            revert Weedies__TheDealersNotAnsweringHisPhone();
        }

        if (msg.value < getMintPrice()) {
            revert Weedies__YouShortedTheDealer();
        }

        if (s_mintCount == s_maxTokenCount) {
            revert Weedies__TheDealersOutOfTheGoodStuff();
        }

        s_mintCount++;
        emit Minted(msg.sender, s_mintCount);
        _mint(msg.sender, s_mintCount);
    }

    function withdraw() external returns (bool) {
        (bool sent,) =
            s_mintRoyaltyRecipient.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");

        return sent;
    }

    function isTimestampInWindow() public view returns (bool) {
        return block.timestamp >= getMintStartTimestamp()
            && block.timestamp <= getMintEndTimestamp();
    }

    function getMintStartTimestamp() public view returns (uint256) {
        return s_mintStartTimestamp;
    }

    function getMintEndTimestamp() public view returns (uint256) {
        return s_mintEndTimestamp;
    }

    function getMintPrice() public view returns (uint256 mintPrice) {
        mintPrice = getAcitveMintingThreshold().mintPrice;
    }

    function getAcitveMintingThreshold()
        public
        view
        returns (MintingThreshold memory threshold)
    {
        for (uint256 i = 0; i < s_mintingThresholds.length; i++) {
            if (
                (s_mintCount >= s_mintingThresholds[i].minThreshold)
                    && (s_mintCount < s_mintingThresholds[i].maxThreshold)
            ) {
                threshold = s_mintingThresholds[i];
                break;
            }
        }
    }

    function getMaxMintCount() external view returns (uint256 maxMintCount) {
        maxMintCount = s_maxTokenCount;
    }

    function getMintCount() external view returns (uint256 mintCount) {
        mintCount = s_mintCount;
    }

    function getMintRoyaltyRecipient() external view returns (address) {
        return s_mintRoyaltyRecipient;
    }

    function _baseURI() internal view override returns (string memory) {
        return s_baseURI;
    }
}
