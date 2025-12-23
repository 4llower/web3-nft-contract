const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();
  const student = process.env.STUDENT_ADDRESS;
  if (!student) {
    throw new Error("Set STUDENT_ADDRESS in env");
  }

  const sbAddress = process.env.SB_ADDRESS;
  const gcAddress = process.env.GC_ADDRESS;
  if (!sbAddress || !gcAddress) {
    throw new Error("Set SB_ADDRESS and GC_ADDRESS to deployed contracts");
  }

  const sb = await hre.ethers.getContractAt(
    "SoulboundVisitCardERC721",
    sbAddress
  );
  const gc = await hre.ethers.getContractAt(
    "GameCharacterCollectionERC1155",
    gcAddress
  );

  console.log("Owner:", owner.address);
  console.log("Student:", student);

  const sbTx = await sb.mintVisitCard(
    student,
    process.env.SB_TOKEN_URI || "ipfs://QmVisitCardMetadata.json",
    process.env.STUDENT_NAME || "Alice",
    process.env.STUDENT_ID || "S123",
    process.env.STUDENT_COURSE || "Blockchain",
    process.env.STUDENT_YEAR || "2025"
  );
  await sbTx.wait();
  console.log("SB minted tx:", sbTx.hash);

  const minted = await gc.initialMinted();
  if (!minted) {
    const initTx = await gc.mintInitialSet();
    await initTx.wait();
    console.log("GC initial mint tx:", initTx.hash);
  } else {
    console.log("Initial set already minted");
  }

  const airdropIds = [0, 1];
  const airdropAmounts = [1, 1];
  const airdropTx = await gc.batchAirdrop(
    student,
    airdropIds,
    airdropAmounts,
    "0x"
  );
  await airdropTx.wait();
  console.log("Airdrop tx:", airdropTx.hash);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
