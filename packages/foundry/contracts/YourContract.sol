//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "forge-std/Test.sol";

contract YourContract is ERC721 {
    error Weedies__AllWeediesAreTwisted();
    error Weedies__UserNotActivelyRollingAWeedie();
    error Weedies__YouShortedTheDealer();
    error Weedies__TheDealersNotAround();

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
    uint256 immutable s_mintDuration;
    uint256 immutable s_maxTokenCount;
    uint256 immutable s_mintStartTimestamp;
    uint256 immutable s_mintEndTimestamp;
    MintingThreshold[] s_mintingThresholds;

    uint256 s_mintCount;

    uint256 s_startMintTimestamp;

    string s_baseURI;

    uint256[] s_MintableTokenIds;
    mapping(address user => uint256 id) s_rolledTokenId;
    mapping(uint256 tokenId => uint256 uriId) mintedTokenUriId;

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

        for (uint256 i = 1; i <= maxTokenCount; i++) {
            s_MintableTokenIds.push(i);
        }
    }

    function rollOneUp() external returns (uint256 tokenId) {
        uint256 result = generateRandomNumberWithFilter(s_maxTokenCount);
        s_rolledTokenId[msg.sender] = result;
        tokenId = result;
    }

    function generateRandomNumberWithFilter(uint256 seed)
        public
        returns (uint256)
    {
        (uint256 randomIndex, uint256 resultNumber) =
            generateRandomNumberWithFilterNoWrite(seed);

        // write the last number of the array to the current position.
        // thus we take out the used number from the circulation and store the last number of the array for future use
        s_MintableTokenIds[randomIndex] =
            s_MintableTokenIds[s_MintableTokenIds.length - 1];

        // reduce the size of the array by 1 (this deletes the last record we’ve copied at the previous step)
        s_MintableTokenIds.pop();

        return resultNumber;
    }

    function generateRandomNumberWithFilterNoWrite(uint256 seed)
        public
        view
        returns (uint256 randomIndex, uint256 resultNumber)
    {
        if (s_MintableTokenIds.length == 0) {
            revert Weedies__AllWeediesAreTwisted();
        }

        uint256 randomSeed = generateRandomNumber(seed);

        // get the random number, divide it by our array size and store the mod of that division.
        // this is to make sure the generated random number fits into our required range
        randomIndex = (randomSeed % s_MintableTokenIds.length);

        // draw the current random number by taking the value at the random index
        resultNumber = (s_MintableTokenIds[randomIndex]);
    }

    function generateRandomNumberWithIndexAccomodation(uint256 seed)
        public
        view
        returns (uint256 randomNumberWithIndexAccomodation)
    {
        randomNumberWithIndexAccomodation = generateRandomNumber(seed) + 1;
    }

    function generateRandomNumber(uint256 ceiling)
        public
        view
        returns (uint256 randomNumber)
    {
        uint256 randomHash = generateRandomHash();
        randomNumber = (randomHash % ceiling);
    }

    function generateRandomHash() public view returns (uint256 randomHash) {
        randomHash = uint256(
            keccak256(
                abi.encodePacked(
                    msg.sender, blockhash(block.number - 1), block.timestamp
                )
            )
        );
    }

    function mint() external payable {
        if (!isTimestampInWindow()) {
            revert Weedies__TheDealersNotAround();
        }

        if (msg.value < getMintPrice()) {
            revert Weedies__YouShortedTheDealer();
        }

        uint256 rolledTokenId = getRolledTokenId(msg.sender);

        if (rolledTokenId == 0) {
            revert Weedies__UserNotActivelyRollingAWeedie();
        }

        s_mintCount++;
        mintedTokenUriId[s_mintCount] = rolledTokenId;
        s_rolledTokenId[msg.sender] = 0;
        _mint(msg.sender, s_mintCount);
    }

    function withdraw() external returns (bool) {
        (bool sent,) =
            s_mintRoyaltyRecipient.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");

        return sent;
    }

    function getRolledTokenId(address user) public view returns (uint256) {
        return s_rolledTokenId[user];
    }

    function getRolledTokenURI(address user)
        public
        view
        returns (string memory uri)
    {
        uri =
            string.concat(_baseURI(), Strings.toString(getRolledTokenId(user)));
    }

    function isTimestampInWindow() public view returns (bool) {
        return block.timestamp >= getMintStartTimestamp()
            && block.timestamp <= getMintEndTimestamp();
    }

    function getMintStartTimestamp() public view returns (uint256) {
        return s_startMintTimestamp;
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

    function getRoyaltyRecipient() external view returns (address) {
        return s_mintRoyaltyRecipient;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory i)
    {
        _requireOwned(tokenId);
        return string.concat(
            _baseURI(), Strings.toString(mintedTokenUriId[tokenId])
        );
    }

    function _baseURI() internal view override returns (string memory) {
        return s_baseURI;
    }
}
