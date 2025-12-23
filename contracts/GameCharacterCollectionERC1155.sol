// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @notice ERC-1155 collection of game characters with fixed metadata.
contract GameCharacterCollectionERC1155 is ERC1155, Ownable {
    struct Character {
        string name;
        string imageURI;
        string color;
        uint8 speed;
        uint8 strength;
        string rarity;
    }

    uint256 public constant TOTAL_IDS = 9; // contiguous IDs 0-8
    mapping(uint256 => string) private _tokenUris;
    mapping(uint256 => Character) private _characters;
    bool public initialMinted;

    constructor(address owner_) ERC1155("") Ownable(owner_) {
        _seedCharacters();
    }

    /// @notice Mint one of each character ID to the owner for distribution.
    function mintInitialSet() external onlyOwner {
        require(!initialMinted, "Already minted");

        uint256[] memory ids = new uint256[](TOTAL_IDS);
        uint256[] memory amounts = new uint256[](TOTAL_IDS);
        for (uint256 i = 0; i < TOTAL_IDS; i++) {
            ids[i] = i;
            amounts[i] = 1;
        }
        initialMinted = true;
        _mintBatch(owner(), ids, amounts, "");
    }

    /// @notice Owner-controlled batch mint to any recipient.
    function mintBatchTo(
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    /// @notice Owner-controlled batch transfer helper to showcase efficiency.
    function batchAirdrop(
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external onlyOwner {
        _safeBatchTransferFrom(owner(), to, ids, amounts, data);
    }

    /// @notice Read character attributes for a given ID.
    function getCharacter(uint256 id) external view returns (Character memory) {
        require(id < TOTAL_IDS, "Invalid id");
        return _characters[id];
    }

    function uri(uint256 id) public view override returns (string memory) {
        require(id < TOTAL_IDS, "Invalid id");
        require(bytes(_tokenUris[id]).length != 0, "URI not set");
        return _tokenUris[id];
    }

    function _seedCharacters() private {
        _characters[0] = Character("Astra Scout", "ipfs://bafybeiec6yfius6ybljvedfvkb2fklt3edpsdge6lugnbynllctu52gmee", "blue", 8, 5, "rare");
        _characters[1] = Character("Blaze Warrior", "ipfs://bafybeih5m67a7qswanelqq6z43wlekv5zxdhhojlxjedouna4hcsbc5wy4", "red", 6, 8, "epic");
        _characters[2] = Character("Dusk Ranger", "ipfs://bafybeicvadbqjedhngi5z2tbsa6ugkil7nplyhzh6i2viecxjl6pc4jcxi", "green", 7, 6, "rare");
        _characters[3] = Character("Ember Mage", "ipfs://bafybeic7rbztj66rwebidkm3g6mkzkibrupbzhvqfl7fsvomscf5h7duku", "crimson", 5, 7, "legendary");
        _characters[4] = Character("Frost Guardian", "ipfs://bafybeicehan3yw2yfq7veuya2wvrielxyiicwpegvycvaj4pzhssstulie", "cyan", 4, 9, "epic");
        _characters[5] = Character("Gale Assassin", "ipfs://bafybeiabjkncygylzyt7pv4xxduzvf4gdrmchk3ekzx4tlrxdrkedjmqym", "silver", 10, 3, "rare");
        _characters[6] = Character("Halo Paladin", "ipfs://bafybeib3otwkjo2ylu3hne5g2namitrm3advv7ugf7psfp25vfswif6ety", "gold", 6, 8, "legendary");
        _characters[7] = Character("Ion Monk", "ipfs://bafybeichedtvbqppfcb254eyq4jj5xpyr2ep2t4y7rdaz2vnpra46a64la", "indigo", 7, 7, "uncommon");
        _characters[8] = Character("Jade Engineer", "ipfs://bafybeib2qbgbewttyr2z3fbtxyhtm5ypzojec3ypgk4efcjsaumdw3ybcm", "jade", 6, 6, "common");

        _tokenUris[0] = "https://ipfs.io/ipfs/bafkreigxva3j32tv6wx4muir7c2ncfiemm6clybr4hufzpi5o6bdxmol7i";
        _tokenUris[1] = "https://ipfs.io/ipfs/bafkreicq6kn4qmcxfcuyjmyod7jhxxn7rkdgr4zqc2dqdb57dr2ogqp7oi";
        _tokenUris[2] = "https://ipfs.io/ipfs/bafkreih22defsie3jlot7k6l6a25iv3fucc3apy7kltuzpnvfodsdpct4y";
        _tokenUris[3] = "https://ipfs.io/ipfs/bafkreid6cot3q4ih54m4s7sb6tzyxojacqhbcuunjlq45cqzdzpi6s4xfa";
        _tokenUris[4] = "https://ipfs.io/ipfs/bafkreib52g4m52sjip2rvkxrdfbdrdtanxqdcfzrmkygmy2dq4i766hs2u";
        _tokenUris[5] = "https://ipfs.io/ipfs/bafkreihpbyvk3xew52xtypifaqymnxdhk4ijazn6hlugqjugagw2u76xda";
        _tokenUris[6] = "https://ipfs.io/ipfs/bafkreienr7cggi4xh7w7scark5yk272qp2q43etyklj3grhyufhl54riiq";
        _tokenUris[7] = "https://ipfs.io/ipfs/bafkreifdezdx23kao5ltdnl2vatpzpbvgvb6oddadjoxmf63y6s5qsreyy";
        _tokenUris[8] = "https://ipfs.io/ipfs/bafkreiaj2p3b32kg7cgy5fvnides5xvzqmvp6yhopobnoiaijz3xtsfpne";
    }
}
