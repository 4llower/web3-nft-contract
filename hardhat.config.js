require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
const RPC_URL = process.env.RPC_URL || "";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";

module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {},
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    sepolia:
      PRIVATE_KEY && RPC_URL
        ? {
            url: RPC_URL,
            accounts: [PRIVATE_KEY],
          }
        : undefined,
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY || undefined,
  },
};
