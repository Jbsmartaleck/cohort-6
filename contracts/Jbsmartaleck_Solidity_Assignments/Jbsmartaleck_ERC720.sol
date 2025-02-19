// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTTransaction is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => string) private _tokenURIs;

    event NFTMinted(address indexed owner, uint256 tokenId, string tokenURI);
    event NFTTransferred(address indexed from, address indexed to, uint256 tokenId);

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(recipient, newTokenId);
        _tokenURIs[newTokenId] = tokenURI;
        emit NFTMinted(recipient, newTokenId, tokenURI);
        return newTokenId;
    }

    function transferNFT(address to, uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You do not own this NFT");
        _transfer(msg.sender, to, tokenId);
        emit NFTTransferred(msg.sender, to, tokenId);
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenURIs[tokenId];
    }
}
