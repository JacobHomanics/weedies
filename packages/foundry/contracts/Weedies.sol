//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "forge-std/Test.sol";

contract Weedies is ERC721, Ownable {
    error Weedies__YouShortedTheDealer();
    error Weedies__TheDealersNotAnsweringHisPhone();
    error Weedies__YouGottaHitUpTheWeedman();
    error Weedies__TheDealersOutOfTheGoodStuff();
    error Weedies__DontHarshOurMellowDude();

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

    mapping(address user => uint256) s_mintAmount;
    uint256 s_maxMintAmountPerUser;
    uint256 s_mintCount;

    string s_baseURI;

    constructor(
        address owner,
        address mintRoyaltyRecipient,
        string memory baseURI,
        uint256 maxTokenCount,
        uint256 mintStartTimestamp,
        uint256 mintEndTimestamp,
        MintingThreshold[] memory mintingThresholds,
        uint256 maxMintAmount,
        address[] memory initialMintRecipients
    ) ERC721("Weedies", "W") Ownable(owner) {
        s_mintRoyaltyRecipient = mintRoyaltyRecipient;
        s_baseURI = baseURI;
        s_maxTokenCount = maxTokenCount;
        s_mintStartTimestamp = mintStartTimestamp;
        s_mintEndTimestamp = mintEndTimestamp;
        s_maxMintAmountPerUser = maxMintAmount;

        for (uint256 i = 0; i < mintingThresholds.length; i++) {
            s_mintingThresholds.push(mintingThresholds[i]);
        }

        for (uint256 i = 0; i < initialMintRecipients.length; i++) {
            _mint(initialMintRecipients[i]);
        }
    }

    function batchMint(uint256 amount) external payable {
        for (uint256 i = 0; i < amount; i++) {
            mint();
        }
    }

    function mint() public payable {
        if (!isWithinConstraints()) {
            revert Weedies__TheDealersNotAnsweringHisPhone();
        }

        if (msg.value < getMintPrice()) {
            revert Weedies__YouShortedTheDealer();
        }

        if (s_mintCount == s_maxTokenCount) {
            revert Weedies__TheDealersOutOfTheGoodStuff();
        }

        if (s_mintAmount[msg.sender] > s_maxMintAmountPerUser) {
            revert Weedies__DontHarshOurMellowDude();
        }

        _mint(msg.sender);
    }

    function _mint(address mintTo) internal {
        s_mintCount++;
        s_mintAmount[mintTo]++;
        emit Minted(mintTo, s_mintCount);
        super._mint(mintTo, s_mintCount);
    }

    function withdraw() external returns (bool) {
        (bool sent,) =
            s_mintRoyaltyRecipient.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");

        return sent;
    }

    function isWithinConstraints() public view returns (bool isWithin) {
        isWithin = isWithinConstraints(
            block.timestamp, getMintStartTimestamp(), getMintEndTimestamp()
        );
    }

    function isWithinConstraints(
        uint256 a,
        uint256 b,
        uint256 c
    ) public pure returns (bool isWithin) {
        if (b == 0 && c == 0) {
            isWithin = true;
        }
        if (b != 0 && c != 0) {
            isWithin = a >= b && a <= c;
        }

        if (b == 0) {
            isWithin = a <= c;
        }

        if (c == 0) {
            isWithin = a >= b;
        }
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
