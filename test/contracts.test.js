const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFT suite", function () {
  let owner, student, other;
  let sb, gc;

  beforeEach(async function () {
    [owner, student, other] = await ethers.getSigners();

    const Sb = await ethers.getContractFactory("SoulboundVisitCardERC721");
    sb = await Sb.deploy(owner.address);
    await sb.waitForDeployment();

    const Gc = await ethers.getContractFactory(
      "GameCharacterCollectionERC1155"
    );
    gc = await Gc.deploy(owner.address);
    await gc.waitForDeployment();
  });

  describe("SoulboundVisitCardERC721", function () {
    it("mints once per student and blocks transfers/approvals", async function () {
      const tx = await sb.mintVisitCard(
        student.address,
        "ipfs://card",
        "Alice",
        "S123",
        "Blockchain",
        "2025"
      );
      await tx.wait();
      expect(await sb.ownerOf(1)).to.equal(student.address);
      expect(await sb.hasCard(student.address)).to.equal(true);

      await expect(
        sb.mintVisitCard(
          student.address,
          "ipfs://card2",
          "Bob",
          "S124",
          "CS",
          "2026"
        )
      ).to.be.revertedWith("Student already has a card");

      await expect(sb.approve(other.address, 1)).to.be.revertedWith(
        "Soulbound: approvals disabled"
      );
      await expect(
        sb.setApprovalForAll(other.address, true)
      ).to.be.revertedWith("Soulbound: approvals disabled");
      await expect(
        sb.transferFrom(student.address, other.address, 1)
      ).to.be.revertedWith("Soulbound: transfer disabled");
      await expect(
        sb.connect(student).safeTransferFrom(student.address, other.address, 1)
      ).to.be.revertedWith("Soulbound: transfer disabled");
    });
  });

  describe("GameCharacterCollectionERC1155", function () {
    it("mints initial set once and airdrops in batch", async function () {
      const initTx = await gc.mintInitialSet();
      await initTx.wait();

      expect(await gc.initialMinted()).to.equal(true);
      // Owner received one of each
      expect(await gc.balanceOf(owner.address, 0)).to.equal(1);
      expect(await gc.balanceOf(owner.address, 8)).to.equal(1);

      await expect(gc.mintInitialSet()).to.be.revertedWith("Already minted");

      const airdropTx = await gc.batchAirdrop(
        student.address,
        [0, 1],
        [1, 1],
        "0x"
      );
      await airdropTx.wait();

      expect(await gc.balanceOf(student.address, 0)).to.equal(1);
      expect(await gc.balanceOf(student.address, 1)).to.equal(1);
      expect(await gc.balanceOf(owner.address, 0)).to.equal(0);

      // Normal transfer should work
      const transferTx = await gc
        .connect(student)
        .safeTransferFrom(student.address, other.address, 1, 1, "0x");
      await transferTx.wait();
      expect(await gc.balanceOf(other.address, 1)).to.equal(1);
    });
  });
});
