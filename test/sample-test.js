const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");





describe("TokenFactory", function () {
  let erc20Contract;
  let token;
  let erc721Contract;
  let nft;

  let factoryContract;
  let tokenFactory;

  let owner;
  let addr1;
  let addr2;
  let addr3;
  let addr4;
  let addr5;
  let addr6;




  before(async function(){

    // First deploy ERC20 token and ERC721 (nft) token

    // Deploying ERC20
    erc20Contract = await ethers.getContractFactory("ERC20Token");
    token =  await erc20Contract.deploy();

    // Deploying ERC721
    erc721Contract = await ethers.getContractFactory("NftToken");
    nft = await erc721Contract.deploy();

    // Deploying Main Factory Contract
    factoryContract = await ethers.getContractFactory("TokenFactory");
    [owner, addr1, addr2, addr3, addr4, addr5, addr6] = await ethers.getSigners();
    tokenFactory = await factoryContract.deploy(nft.address, token.address);

  })


  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();
 
    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
