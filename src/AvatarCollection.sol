// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AvatarCollection is ERC721, Ownable {
    uint256 private _tokenIds;

    struct ChainMetadata {
        string chainName;
        uint256 chainId;
    }

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => ChainMetadata) public tokenChainData;

    constructor(string memory name, string memory symbol, address initialOwner) ERC721(name, symbol) Ownable(initialOwner) {}

    function mintAvatar(address to, string memory tokenURI, string memory chainName, uint256 chainId) external onlyOwner {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;

        _mint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        tokenChainData[newTokenId] = ChainMetadata(chainName, chainId);
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = tokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function getChainMetadata(uint256 tokenId) public view returns (string memory chainName, uint256 chainId) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        ChainMetadata memory metadata = tokenChainData[tokenId];
        return (metadata.chainName, metadata.chainId);
    }
}
