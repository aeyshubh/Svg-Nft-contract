// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
//0xd7367433aD2CFC7b6dd87265778B205Bc1cf97C3
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    struct character {
        uint256 _timestamp;
        uint256 _battelsPlayed;
        uint256 _Level;
        uint256 _charType;
        uint256 _Speciality;
        bool _sts;
    }
    mapping(uint256 => character) Levels;

    constructor() ERC721("Battle On Chain", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: black; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="teal" />',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Nft Type:",
            getCharacter(tokenId),
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            getSpeciality(tokenId),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            getLevels(tokenId),
            "</text>",
            '<text x="45%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "BattlePlayed: ",
            getBattlePlayed(tokenId),
            "</text>",
            '<text x="45%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Alive/Dead: ",
            getLife(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        return Levels[tokenId]._Level.toString();
    }

    function getCharacter(uint256 tokenId) public view returns (string memory) {
        if (Levels[tokenId]._charType == 1) {
            string memory _type = "Warrior";
            return _type;
        } else {
            return "Mage";
        }
    }

    function getSpeciality(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        if (Levels[tokenId]._Speciality == 1) {
            string memory _type = "Sword";
            return _type;
        } else {
            return "Magic";
        }
    }

    function getBattlePlayed(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        return Levels[tokenId]._charType.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        if (block.timestamp <= Levels[tokenId]._timestamp) {
            return "Alive";
        } else {
            return "Dead";
        }
    }

    function getTokenURI(uint256 tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Battle On Chain #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain is a Nft created by Shubham Patel in EthIndia Fellowship at Week-4",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint(uint256 charType, uint256 speciality) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Levels[newItemId]._charType = charType;
        Levels[newItemId]._Speciality = speciality;
        Levels[newItemId]._timestamp = block.timestamp;

        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public payable {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        require(
            msg.value > 0.001 ether,
            "Send 0.001 ether to Train your character"
        );
        Levels[tokenId]._Level = Levels[tokenId]._Level + 1;
        Levels[tokenId]._timestamp = Levels[tokenId]._timestamp + 864000;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function incrementBattle(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );
        require(
            Levels[tokenId]._timestamp <= block.timestamp,
            "Your player is dead,make him alive"
        );
        Levels[tokenId]._battelsPlayed = Levels[tokenId]._battelsPlayed + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
