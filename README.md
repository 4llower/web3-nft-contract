# Soulbound Visit Card (ERC-721) and Game Characters (ERC-1155)

End-to-end Hardhat project with two standalone contracts: a non-transferable student visit card (ERC-721) and a game character collection (ERC-1155). Both use OpenZeppelin 0.8.x and are wired for IPFS/off-chain metadata.

## Layout

- [contracts/SoulboundVisitCardERC721.sol](contracts/SoulboundVisitCardERC721.sol)
- [contracts/GameCharacterCollectionERC1155.sol](contracts/GameCharacterCollectionERC1155.sol)
- [scripts/deploy.js](scripts/deploy.js): deploy both contracts.
- [scripts/demoFlow.js](scripts/demoFlow.js): mint soulbound card, initial ERC-1155 set, and batch airdrop to a student.
- [test/contracts.test.js](test/contracts.test.js): basic behavior tests (soulbound checks, ERC-1155 batch flow).
- [metadata](metadata): sample JSON files for ERC-721 card and ERC-1155 characters (IDs now contiguous 0-8).

## Install

```bash
npm install
```

## Configure environment

Create `.env` (never commit secrets):

```
PRIVATE_KEY=0x...
RPC_URL=https://sepolia.infura.io/v3/<key>
ETHERSCAN_API_KEY=<optional>

# demoFlow params
STUDENT_ADDRESS=0xStudent
SB_ADDRESS=0xDeployedSoulbound
GC_ADDRESS=0xDeployedGameCollection
SB_TOKEN_URI=ipfs://QmVisitCardMetadata.json
STUDENT_NAME=Alice
STUDENT_ID=S123
STUDENT_COURSE=Blockchain
STUDENT_YEAR=2025
```

## Compile and test

```bash
npx hardhat compile
npx hardhat test
```

## Deploy

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

Outputs contract addresses for reuse in `demoFlow`.

## Demo flow (mint + airdrop)

With `.env` set to deployed addresses and student:

```bash
npx hardhat run scripts/demoFlow.js --network sepolia
```

- Mints a soulbound card to the student with metadata URI and profile fields.
- If not already done, mints one of each ERC-1155 character to the owner.
- Batch airdrops token IDs `[0,1]` to the student.

## Contract behaviors

### Soulbound ERC-721

- Owner-only mint: `mintVisitCard(to, tokenURI, studentName, studentId, course, year)`
- One card per wallet enforced by `hasCard`.
- Approvals, transfers, and burns revert after mint (soulbound).
- Profile data query: `getProfile(tokenId)`.

### Game Characters ERC-1155

- Active IDs: 0-8 contiguous (Cinder Rogue removed; IDs shifted).
- `mintInitialSet()` once to owner (one of each ID).
- `mintBatchTo(to, ids, amounts, data)` for owner-controlled batch minting.
- `batchAirdrop(to, ids, amounts, data)` batch transfers from owner.
- Standard ERC-1155 transfers/approvals remain enabled.

## Metadata

Sample JSON is in [metadata](metadata). Replace placeholder `ipfs://Qm...` CIDs with actual uploads. Ensure each URI in the contracts points to the corresponding uploaded file:

- ERC-721 example: [metadata/erc721-visit-card.json](metadata/erc721-visit-card.json)
- ERC-1155 examples: [metadata/erc1155-char-0.json](metadata/erc1155-char-0.json), [metadata/erc1155-char-1.json](metadata/erc1155-char-1.json), [metadata/erc1155-char-2.json](metadata/erc1155-char-2.json), [metadata/erc1155-char-3.json](metadata/erc1155-char-3.json), [metadata/erc1155-char-4.json](metadata/erc1155-char-4.json), [metadata/erc1155-char-5.json](metadata/erc1155-char-5.json), [metadata/erc1155-char-6.json](metadata/erc1155-char-6.json), [metadata/erc1155-char-7.json](metadata/erc1155-char-7.json), [metadata/erc1155-char-8.json](metadata/erc1155-char-8.json)

## Proof to capture

- Tx hash for ERC-721 mint to student.
- Tx hash for ERC-1155 initial mint (or batch mint) and the batch airdrop.
- Optional explorer screenshots showing received tokens.
