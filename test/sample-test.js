const { inputToConfig } = require("@ethereum-waffle/compiler");
const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat");


// let erc20Tkn;
// let erc20OwnerAddr;
let nftTkn;


const _name = "SSL Token";
const _symbol = "SSL";
const _supply = BigNumber.from("10000000");


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

  before(async function () {

    // First deploy ERC20 token and ERC721 (nft) token

    // Deploying ERC20
    erc20Contract = await ethers.getContractFactory("ERC20Token");
    token = await erc20Contract.deploy();

    // Deploying ERC721
    erc721Contract = await ethers.getContractFactory("NftToken");
    nft = await erc721Contract.deploy();

    // Deploying Main Factory Contract
    factoryContract = await ethers.getContractFactory("TokenFactory");
    [owner, addr1, addr2, addr3, addr4, addr5, addr6] = await ethers.getSigners();
    tokenFactory = await factoryContract.deploy(nft.address, token.address);

  })

  describe("Deploy Factory Contract", function () {
    it("Factory Contract deployment should set \"pauseAllStatus\" to true", async function () {
      expect(await tokenFactory.getPauseAllStatus()).to.equal(true);
    })

  })

  describe("Deploy ERC20 dynamically", function () {
    it("Should deploy ERC20 token dynamically.", async function () {
      
      const tokenDeployed = await tokenFactory.createToken(_name, _symbol, _supply);
      const waitData = await tokenDeployed.wait();
      const erc20Addr = waitData.events[2].args.erc20Address;
      const erc20OwnerAddr = waitData.events[2].args.ownerAddress;
      const erc20Tkn = erc20Contract.attach(erc20Addr);
      console.log(await erc20Tkn._msgSender());
      expect(await erc20Tkn.name()).to.equal(_name);
      expect(await erc20Tkn.symbol()).to.equal(_symbol);
      expect(await erc20Tkn.totalSupply()).to.equal(_supply);
      expect(await erc20Tkn.balanceOf(erc20OwnerAddr)).to.equal(_supply);

    });

    // it("Should mint token by owner", async function(){

    //   const tokenDeployed = await tokenFactory.createToken(_name, _symbol, _supply);

    //   const waitData = await tokenDeployed.wait();
    //   const erc20DeployedAddr = waitData.events[2].args.erc20Address;
    //   const erc20OwnerAddr = waitData.events[2].args.ownerAddress;

    //   const erc20Tkn = erc20Contract.attach(erc20DeployedAddr);

    //   const preSupply = await erc20Tkn.balanceOf(addr1.address);

    //   await erc20Tkn.call(abi.encodeWithSignature("mintToken(address, uin256)",addr1.address, BigNumber.from("40000")));

    //   expect(await erc20Tkn.balanceOf(addr1.address)).to.equal(BigNumber.from("40000").add(preSupply));
    // })
  })

  //0xE451980132E65465d0a498c53f0b5227326Dd73F
  //

  // describe("Deploy ERC721 dynamically", function(){

  // })

  // describe("Owners of dynamically deployed contracts", function(){

  // })  

  // describe("Pause Contract.", function(){


  // })

  // describe("Pause All Contracts at once.", function(){


  // })




});
