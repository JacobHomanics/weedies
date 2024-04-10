//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "forge-std/Test.sol";

contract YourContract is AccessControl, ERC721 {
    error Weedies__AllWeediesAreTwisted();
    error Weedies__UserNotActivelyRollingAWeedie();
    error Weedies__YouShortedTheDealer();
    error Weedies__TheDealersNotAround();
    error Weedies__YouGottaHitUpTheWeedman();

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

    string s_baseURI;

    uint256[] s_MintableTokenIds;
    mapping(address user => uint256 id) s_rolledTokenId;
    mapping(address user => uint256[] ids) s_rolledTokenIds;
    mapping(address user => uint256 index) s_rolledTokenIndex;
    mapping(address user => uint256[] indices) s_rolledTokenIndices;

    mapping(uint256 tokenId => uint256 uriId) mintedTokenUriId;

    constructor(
        address admin,
        address mintRoyaltyRecipient,
        string memory baseURI,
        uint256 maxTokenCount,
        uint256 mintStartTimestamp,
        uint256 mintEndTimestamp,
        MintingThreshold[] memory mintingThresholds
    ) ERC721("Weedies", "W") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);

        s_mintRoyaltyRecipient = mintRoyaltyRecipient;
        s_baseURI = baseURI;
        s_maxTokenCount = maxTokenCount;
        s_mintStartTimestamp = mintStartTimestamp;
        s_mintEndTimestamp = mintEndTimestamp;

        for (uint256 i = 0; i < mintingThresholds.length; i++) {
            s_mintingThresholds.push(mintingThresholds[i]);
        }
    }

    function setUpMintableTokenIds(uint256 numToMake)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        uint256 lengthOfArrWithIndexAccomdation = s_MintableTokenIds.length + 1;

        uint256 newEndIndex = lengthOfArrWithIndexAccomdation + numToMake;

        for (uint256 i = lengthOfArrWithIndexAccomdation; i < newEndIndex; i++)
        {
            s_MintableTokenIds.push(i);
        }
    }

    // function rollUp() external returns (uint256 numToRoll) {
    //     s_rolledTokenIds[msg.sender] = new uint256[](0);
    //     s_rolledTokenIndices[msg.sender] = new uint256[](0);

    //     uint256[] memory pooledTokenIds = s_MintableTokenIds;

    //     for (uint256 i = 0; i < numToRoll; i++) {
    //         (uint256 index, uint256 result) =
    //         generateRandomNumberWithFilterNoWrite(
    //             s_maxTokenCount, pooledTokenIds
    //         );
    //         s_rolledTokenIds[msg.sender].push(result);
    //         s_rolledTokenIndices[msg.sender].push(index);
    //     }
    // }
    // 120381147977
    // 119910872780
    // 116274327
    // 440658470

    function rollOneUp() external returns (uint256 tokenId) {
        (uint256 index, uint256 result) =
            generateRandomNumberWithFilterNoWrite(s_maxTokenCount);
        s_rolledTokenId[msg.sender] = result;
        s_rolledTokenIndex[msg.sender] = index;
        tokenId = result;

        // uint256[] memory pooledTokenIds = s_MintableTokenIds;

        // for (uint256 i = 0; i < 5; i++) {
        //     (uint256 index, uint256 result) =
        //         generateRandomNumberWithFilterNoWrite(s_maxTokenCount, pooledTokenIds);
        //     s_rolledTokenId[msg.sender] = result;
        //     s_rolledTokenIndex[msg.sender] = index;
        //     tokenId = result;
        // }
    }

    // function generateRandomNumberWithFilter(uint256 seed)
    //     public
    //     returns (uint256)
    // {
    //     (uint256 randomIndex, uint256 resultNumber) =
    //         generateRandomNumberWithFilterNoWrite(seed);

    //     // write the last number of the array to the current position.
    //     // thus we take out the used number from the circulation and store the last number of the array for future use
    //     s_MintableTokenIds[randomIndex] =
    //         s_MintableTokenIds[s_MintableTokenIds.length - 1];

    //     // reduce the size of the array by 1 (this deletes the last record we’ve copied at the previous step)
    //     s_MintableTokenIds.pop();

    //     return resultNumber;
    // }

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

    function generateRandomNumberWithFilterNoWrite(
        uint256 seed,
        uint256[] memory pooledTokenIds
    ) public view returns (uint256 randomIndex, uint256 resultNumber) {
        if (pooledTokenIds.length == 0) {
            revert Weedies__AllWeediesAreTwisted();
        }

        uint256 randomSeed = generateRandomNumber(seed);

        // get the random number, divide it by our array size and store the mod of that division.
        // this is to make sure the generated random number fits into our required range
        randomIndex = (randomSeed % pooledTokenIds.length);

        // draw the current random number by taking the value at the random index
        resultNumber = (pooledTokenIds[randomIndex]);
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
        console.log("origin: ", tx.origin);
        console.log("sender: ", msg.sender);

        randomHash = uint256(
            keccak256(
                abi.encodePacked(
                    msg.sender, blockhash(block.number - 1), block.timestamp
                )
            )
        );

        console.log(randomHash);
    }

    function mint() external payable {
        if (!isTimestampInWindow()) {
            revert Weedies__TheDealersNotAround();
        }

        if (msg.value < getMintPrice()) {
            revert Weedies__YouShortedTheDealer();
        }

        uint256 rolledTokenId = getRolledTokenId(msg.sender);
        uint256 rolledTokenIndex = getRolledTokenIndex(msg.sender);

        if (rolledTokenId == 0) {
            revert Weedies__UserNotActivelyRollingAWeedie();
        }

        s_mintCount++;
        mintedTokenUriId[s_mintCount] = rolledTokenId;
        s_rolledTokenId[msg.sender] = 0;
        s_rolledTokenIndex[msg.sender] = 0;

        // write the last number of the array to the current position.
        // thus we take out the used number from the circulation and store the last number of the array for future use
        if (s_MintableTokenIds.length > 1) {
            s_MintableTokenIds[rolledTokenIndex] =
                s_MintableTokenIds[s_MintableTokenIds.length - 1];
        }

        // reduce the size of the array by 1 (this deletes the last record we’ve copied at the previous step)
        s_MintableTokenIds.pop();

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

    function getRolledTokenIndex(address user) public view returns (uint256) {
        return s_rolledTokenIndex[user];
    }

    function getRolledTokenURI(address user)
        public
        view
        returns (string memory uri)
    {
        uint256 tokenId = getRolledTokenId(user);
        if (tokenId == 0) {
            revert Weedies__YouGottaHitUpTheWeedman();
        }

        uri =
            string.concat(_baseURI(), Strings.toString(getRolledTokenId(user)));
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

    function getMintableTokenIds() public view returns (uint256[] memory) {
        return s_MintableTokenIds;
    }

    function getMintsLeft() public view returns (uint256) {
        return s_MintableTokenIds.length;
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
