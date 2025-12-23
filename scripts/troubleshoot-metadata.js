const hre = require("hardhat");

// Builds a public gateway URL from an ipfs:// URI
function toGateway(uri, gateway = "https://ipfs.io/ipfs/") {
  if (!uri) return "";
  if (uri.startsWith("ipfs://")) {
    return gateway + uri.replace("ipfs://", "");
  }
  return uri; // already http(s)
}

async function main() {
  const sbAddress = process.env.SB_ADDRESS;
  const gcAddress = process.env.GC_ADDRESS;
  if (!sbAddress || !gcAddress) {
    throw new Error("Set SB_ADDRESS and GC_ADDRESS in .env");
  }

  const sb = await hre.ethers.getContractAt(
    "SoulboundVisitCardERC721",
    sbAddress
  );
  const gc = await hre.ethers.getContractAt(
    "GameCharacterCollectionERC1155",
    gcAddress
  );

  console.log("Network:", hre.network.name);
  console.log("SB_ADDRESS:", sbAddress);
  console.log("GC_ADDRESS:", gcAddress);

  // Check ERC-721 token 1 URI
  try {
    const uri721 = await sb.tokenURI(1);
    console.log("ERC721 tokenURI(1):", uri721);
    console.log("Gateway:", toGateway(uri721));
  } catch (e) {
    console.log("ERC721 tokenURI(1) failed:", e.message || e);
  }

  // Check ERC-1155 URIs for IDs 0-8
  for (let id = 0; id < 9; id++) {
    try {
      const uri1155 = await gc.uri(id);
      // console.log(`ERC1155 uri(${id}):`, uri1155);
      console.log(`Gateway ${id}:`, toGateway(uri1155));
    } catch (e) {
      console.log(`ERC1155 uri(${id}) failed:`, e.message || e);
    }
  }
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
