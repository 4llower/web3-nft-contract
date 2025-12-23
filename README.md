# Soulbound Visit Card (ERC-721) and Game Characters (ERC-1155)

Hardhat project with two contracts: a soulbound student visit card (ERC-721) and a game character collection (ERC-1155). Metadata is hosted on IPFS; ERC-1155 URIs use HTTPS gateways for explorer compatibility.

## Layout

- [contracts/SoulboundVisitCardERC721.sol](contracts/SoulboundVisitCardERC721.sol)
- [contracts/GameCharacterCollectionERC1155.sol](contracts/GameCharacterCollectionERC1155.sol)
- Scripts: deploy ([scripts/deploy-local.js](scripts/deploy-local.js), [scripts/deploy-sepolia.js](scripts/deploy-sepolia.js)), demo ([scripts/demoFlow.js](scripts/demoFlow.js)), metadata check ([scripts/troubleshoot-metadata.js](scripts/troubleshoot-metadata.js))
- Tests: [test/contracts.test.js](test/contracts.test.js)
- Metadata samples: [metadata](metadata)

## Install

```bash
npm install
```

## .env template (never commit secrets)

```
PRIVATE_KEY=0x...
RPC_URL=https://sepolia.infura.io/v3/<key>
ETHERSCAN_API_KEY=<optional>
STUDENT_ADDRESS=0xStudent
SB_ADDRESS=0xDeployedSoulbound
GC_ADDRESS=0xDeployedGameCollection
SB_TOKEN_URI=https://ipfs.io/ipfs/<cid>
STUDENT_NAME=Alice
STUDENT_ID=S123
STUDENT_COURSE=Blockchain
STUDENT_YEAR=2025
```

## Commands

- Compile/tests: `npm run compile` / `npm run test`
- Deploy local: `npm run deploy:local` (requires `npx hardhat node` running)
- Deploy Sepolia: `npm run deploy:sepolia`
- Demo mint/airdrop: `npm run demo:sepolia` (or `demo:local`)
- Metadata check: `npm run troubleshoot:metadata` (uses `SB_ADDRESS`/`GC_ADDRESS`)

## Flow

1. Deploy (local or Sepolia) and note SB/GC addresses.
2. Set `SB_ADDRESS`, `GC_ADDRESS`, and `STUDENT_ADDRESS` in `.env`.
3. Run demo to mint the soulbound card to the student, mint initial ERC-1155 set, and airdrop IDs [0,1] to the student.
4. View in wallet/explorer: use the contract addresses and token IDs (ERC-721 ID 1; ERC-1155 IDs 0,1 airdropped). If the wallet struggles with `ipfs://`, use the HTTPS gateway links from `troubleshoot-metadata` output.

## Notes

- ERC-1155 `uri(id)` now returns HTTPS gateway URLs for better explorer fetching.
- Node 25 is unsupported by Hardhat; prefer Node 18/20.
- If metadata changes, update URIs and redeploy/mint as needed.

### Deployment (Sepolia)

- Deployer: 0x28735d9037854FDa36217C594f8fd550B383b04A
- SoulboundVisitCardERC721: 0xe0A109d083f0bE9144FE7f525B1d3174fe55c60E
- GameCharacterCollectionERC1155: 0x657DE49238c6c476c78B4f15354ff932A4f78927

### Demo txs (Sepolia)

- Owner/Student: 0x28735d9037854FDa36217C594f8fd550B383b04A
- SB minted tx: 0x3f81da4833483f04f9bcab1744b2fbe33a08dbc93fb8839feb51739953472967
- GC initial mint tx: 0xacab7d148ce423d9946ca20963a443a478b0e0ed7a71622914553e037673caac
- Airdrop tx: 0x455b456ab6cf8ced8be7ed2fd8a8d1ca6847b69465c96202f71766cbe691e357

### Metadata checks

Logs from troubleshoot-metadata.js (verification that contracts returns proper uris)

- SB tokenURI(1): ipfs://bafkreihq3k6ejonz7uyn6xuqwmegnjwiaiccumahl4znkn6u4awdc6f5c4
- GC uris (0-8):
  - 0: https://ipfs.io/ipfs/bafkreigxva3j32tv6wx4muir7c2ncfiemm6clybr4hufzpi5o6bdxmol7i
  - 1: https://ipfs.io/ipfs/bafkreicq6kn4qmcxfcuyjmyod7jhxxn7rkdgr4zqc2dqdb57dr2ogqp7oi
  - 2: https://ipfs.io/ipfs/bafkreih22defsie3jlot7k6l6a25iv3fucc3apy7kltuzpnvfodsdpct4y
  - 3: https://ipfs.io/ipfs/bafkreid6cot3q4ih54m4s7sb6tzyxojacqhbcuunjlq45cqzdzpi6s4xfa
  - 4: https://ipfs.io/ipfs/bafkreib52g4m52sjip2rvkxrdfbdrdtanxqdcfzrmkygmy2dq4i766hs2u
  - 5: https://ipfs.io/ipfs/bafkreihpbyvk3xew52xtypifaqymnxdhk4ijazn6hlugqjugagw2u76xda
  - 6: https://ipfs.io/ipfs/bafkreienr7cggi4xh7w7scark5yk272qp2q43etyklj3grhyufhl54riiq
  - 7: https://ipfs.io/ipfs/bafkreifdezdx23kao5ltdnl2vatpzpbvgvb6oddadjoxmf63y6s5qsreyy
  - 8: https://ipfs.io/ipfs/bafkreiaj2p3b32kg7cgy5fvnides5xvzqmvp6yhopobnoiaijz3xtsfpne

### Note

I tried adding the NFTs to MetaMask, but they do not render. The contract calls return valid metadata and the URIs are reachable via gateway; likely a Sepolia/visibility limitation in the wallet. I rechecked multiple times and could not find a functional issue. I really enjoyed generating the images for this lab, but didn't succeed in adding it to metamask :(
