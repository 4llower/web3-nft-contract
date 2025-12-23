const hre = require("hardhat");

async function main() {
  console.log("Network:", hre.network.name);
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer:", deployer.address);

  const Sb = await hre.ethers.getContractFactory("SoulboundVisitCardERC721");
  const sb = await Sb.deploy(deployer.address);
  await sb.waitForDeployment();
  console.log("SoulboundVisitCardERC721 deployed at:", sb.target);

  const Gc = await hre.ethers.getContractFactory(
    "GameCharacterCollectionERC1155"
  );
  const gc = await Gc.deploy(deployer.address);
  await gc.waitForDeployment();
  console.log("GameCharacterCollectionERC1155 deployed at:", gc.target);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
