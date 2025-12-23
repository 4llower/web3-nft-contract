// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @notice Soulbound ERC-721 representing a student's visit card.
/// Only the contract owner can mint exactly one card per student wallet.
contract SoulboundVisitCardERC721 is ERC721, Ownable {

    struct StudentProfile {
        string studentName;
        string studentId;
        string course;
        string year;
    }

    uint256 private _tokenIds;
    mapping(address => bool) public hasCard;
    mapping(uint256 => StudentProfile) private _profiles;
    mapping(uint256 => string) private _tokenURIs;

    constructor(address owner_) ERC721("Soulbound Student Visit Card", "SBVC") Ownable(owner_) {}

    /// @notice Mint a soulbound visit card to a student wallet with metadata URI and profile fields.
    function mintVisitCard(
        address to,
        string calldata tokenURI_,
        string calldata studentName,
        string calldata studentId,
        string calldata course,
        string calldata year
    ) external onlyOwner returns (uint256) {
        require(!hasCard[to], "Student already has a card");
        require(to != address(0), "Invalid recipient");

        _tokenIds += 1;
        uint256 newTokenId = _tokenIds;

        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI_);

        _profiles[newTokenId] = StudentProfile({
            studentName: studentName,
            studentId: studentId,
            course: course,
            year: year
        });

        hasCard[to] = true;
        return newTokenId;
    }

    /// @notice View structured profile data for a token.
    function getProfile(uint256 tokenId) external view returns (StudentProfile memory) {
        require(_ownerOf(tokenId) != address(0), "Nonexistent token");
        return _profiles[tokenId];
    }

    /// @dev Disable approvals entirely.
    function approve(address, uint256) public pure override(ERC721) {
        revert("Soulbound: approvals disabled");
    }

    function setApprovalForAll(address, bool) public pure override(ERC721) {
        revert("Soulbound: approvals disabled");
    }

    /// @dev Block transfers and burns after mint.
    function _update(address to, uint256 tokenId, address auth)
        internal
        override
        returns (address)
    {
        address from = super._update(to, tokenId, auth);
        // Mint: from == address(0), allowed. Anything else (transfer or burn) reverts.
        if (from != address(0)) {
            revert("Soulbound: non-transferable");
        }
        return from;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Nonexistent token");
        return _tokenURIs[tokenId];
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI_) internal {
        _tokenURIs[tokenId] = tokenURI_;
    }
}
