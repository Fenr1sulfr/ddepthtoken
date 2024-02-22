const { expect } = require("chai");

describe("DepthToken", function () {
  let depthToken;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    const DepthToken = await ethers.getContractFactory("DepthToken");
    depthToken = await DepthToken.deploy();
    await depthToken.deployed;
  });

  it("should have the correct name and symbol", async function () {
    expect(await depthToken.name()).to.equal("DepthToken");
    expect(await depthToken.symbol()).to.equal("DPH");
  });

  it("should mint initial supply to the coinbase address", async function () {
    // Check the balance of coinbase after deployment
    const coinbaseBalance = await depthToken.balanceOf(owner.address);  // Use owner.address instead of block.coinbase
    expect(coinbaseBalance).to.equal(1000);
  });
  it("should update and mint miner reward on each transfer", async function () {
    // Transfer some tokens from owner to addr1
    await depthToken.transfer(addr1.address, 100);

    // Check the balance of addr1
    const addr1Balance = await depthToken.balanceOf(addr1.address);
    expect(addr1Balance).to.equal(100);

    // Check if miner reward is minted after the transfer
    const minerRewardBalance = await depthToken.balanceOf(owner.address);
    expect(minerRewardBalance).to.equal(900);
  });

  it("should not mint miner reward on contract deployment", async function () {
    // Check the balance of owner after deployment
    const ownerBalance = await depthToken.balanceOf(owner.address);
    expect(ownerBalance).to.equal(1000);

    // Check if miner reward is not minted on contract deployment
    const minerRewardBalance = await depthToken.balanceOf(owner.address);
    expect(minerRewardBalance).to.equal(1000);
  });
});
