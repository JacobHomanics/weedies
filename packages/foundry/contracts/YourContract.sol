//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract YourContract is AccessControl, ERC721 {
    error YourContract__DidNotSendEnoughEther();
    error YourContract__PastMintWindow();
    error YourContract__BeforeMintWindow();
    error YourContract__MintNotStarted();
    error YourContract__MintAlreadyStarted();

    struct MintingThreshold {
        uint256 minThreshold;
        uint256 maxThreshold;
        uint256 mintPrice;
    }

    address immutable s_mintRoyaltyRecipient;
    uint256 immutable s_mintPrice;
    uint256 s_mintCount;

    MintingThreshold[] mintingThresholds;

    uint256 s_maxMintCount;

    uint256 s_mintDuration = 24 hours;
    uint256 s_startMintTimestamp;

    bool s_isMintStarted;

    constructor(
        address admin,
        address mintRoyaltyRecipient,
        uint256 maxMintCount,
        uint256 mintDuration
    ) ERC721("Weedies", "W") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);

        s_mintRoyaltyRecipient = mintRoyaltyRecipient;
        s_mintPrice = 0;
        s_maxMintCount = maxMintCount;
        s_mintDuration = mintDuration;

        mintingThresholds.push(MintingThreshold(0, 5, 0.00069420 ether));
        mintingThresholds.push(MintingThreshold(5, 10, .1 ether));
        mintingThresholds.push(
            MintingThreshold(10, type(uint256).max, 1 ether)
        );
    }

    function startMint() external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (s_isMintStarted) {
            revert YourContract__MintAlreadyStarted();
        }

        s_startMintTimestamp = block.timestamp;
        s_isMintStarted = true;
    }

    function getIsMintStarted() external view returns (bool isMintStarted) {
        isMintStarted = s_isMintStarted;
    }

    function getMintDuration() external view returns (uint256 mintDuration) {
        mintDuration = s_mintDuration;
    }

    function getStartMintTimestamp()
        external
        view
        returns (uint256 startMintTimestamp)
    {
        startMintTimestamp = s_startMintTimestamp;
    }

    function mint() external payable {
        if (!s_isMintStarted) {
            revert YourContract__MintNotStarted();
        }

        if (block.timestamp < s_startMintTimestamp) {
            revert YourContract__BeforeMintWindow();
        }

        if (block.timestamp > s_startMintTimestamp + s_mintDuration) {
            revert YourContract__PastMintWindow();
        }

        uint256 mintPrice = getAcitveMintingThreshold().mintPrice;

        if (msg.value < mintPrice) {
            revert YourContract__DidNotSendEnoughEther();
        }

        s_mintCount++;
        _mint(msg.sender, s_mintCount);
    }

    function withdraw() external {
        (bool sent, ) = s_mintRoyaltyRecipient.call{
            value: address(this).balance
        }("");
        require(sent, "Failed to send Ether");
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://nft.bueno.art/api/contract/0zJlzGVsEKj7cALqS-QMX/chain/1/metadata/";
    }

    function getMaxMintCount() external view returns (uint256 maxMintCount) {
        maxMintCount = s_maxMintCount;
    }

    function getMintCount() external view returns (uint256 mintCount) {
        mintCount = s_mintCount;
    }

    function getRoyaltyRecipient() external view returns (address) {
        return s_mintRoyaltyRecipient;
    }

    function getAcitveMintingThreshold()
        public
        view
        returns (MintingThreshold memory threshold)
    {
        for (uint256 i = 0; i < mintingThresholds.length; i++) {
            if (
                (s_mintCount >= mintingThresholds[i].minThreshold) &&
                (s_mintCount < mintingThresholds[i].maxThreshold)
            ) {
                threshold = mintingThresholds[i];
                break;
            }
        }
    }
}
