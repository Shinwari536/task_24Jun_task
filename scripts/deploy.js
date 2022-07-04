// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

   // erc20 token
   const tokenContract = await hre.ethers.getContractFactory("ERC20Token");
   const token = await tokenContract.deploy();
   await token.deployed();
 
   console.log("erc20 token address: ", token.address);
 
   
   //nft
   const nfContract = await hre.ethers.getContractFactory("NftToken");
   const nft = await nfContract.deploy();
   await nft.deployed();
 
   console.log("nft address: ", nft.address);

  const [deployer] = await ethers.getSigners();
  const factoryContract = await hre.ethers.getContractFactory("TokenFactory");
  const factory = await factoryContract.deploy(nft.address, token.address);
  await factory.deployed();

  console.log("factory address: ", factory.address);


  // We get the contract to deploy

 


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
