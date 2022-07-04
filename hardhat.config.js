require('@typechain/hardhat')
require('@nomiclabs/hardhat-ethers')
require('@nomiclabs/hardhat-waffle')
require("@nomiclabs/hardhat-etherscan");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').
 */

const API_KEY = "d56ee36b62fc46cbad3781027cb5cdcb";
const Ropsten_PRIVATE_KEY = "d20bd32d2431d8543982f40b6205b3f5ce86b990109ed2413b36b3f121881247";
module.exports = {
  solidity: "0.8.4",
  networks: {
    ropsten: {
      url: `https://ropsten.infura.io/v3/${API_KEY}`,
      accounts: [`0x${Ropsten_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "KBFZADV4S2NTYPFI1XNAF3BIA3QWDEUUMA"
  }
};
