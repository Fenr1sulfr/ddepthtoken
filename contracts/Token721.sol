// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyERC721Token
 * @dev An ERC721 token with additional features, including metadata URI management and ownership control.
 */
contract MyERC721Token is ERC721, Ownable {
    // Token name and symbol
    string private _name;
    string private _symbol;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // Token ID counter
    uint256 private _tokenIdCounter;

    /**
     * @dev Constructor to initialize the ERC721 token.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param initialOwner The initial owner of the contract.
     */
    constructor(string memory name_, string memory symbol_, address initialOwner) ERC721(name_, symbol_) Ownable(initialOwner) {
        _name = name_;
        _symbol = symbol_;
        _tokenIdCounter = 0;
    }

    /**
     * @dev Function to mint new tokens, only callable by the owner.
     * @param to The address to which the new token will be minted.
     */
    function mint(address to) external onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _tokenIdCounter++;
    }

    /**
     * @dev Function to set the URI for a token, only callable by the owner.
     * @param tokenId The ID of the token.
     * @param tokenURI The URI to be set for the token's metadata.
     */
    function updateTokenURI(uint256 tokenId, string memory tokenURI) external onlyOwner {
        _tokenURIs[tokenId] = tokenURI;
    }

    /**
     * @dev Function to get the token URI.
     * @param tokenId The ID of the token.
     * @return The URI associated with the token's metadata.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    /**
     * @dev Function to update the name and symbol of the token, only callable by the owner.
     * @param newName The new name for the token.
     * @param newSymbol The new symbol for the token.
     */
    function updateTokenInfo(string memory newName, string memory newSymbol) external onlyOwner {
        _name = newName;
        _symbol = newSymbol;
    }

    // Additional functions or events can be documented here.
}
