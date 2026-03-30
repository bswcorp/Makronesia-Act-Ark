require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.0",
  networks: {
    polygon: {
      url: "https://polygon-rpc.com", // Public RPC
      accounts: ["0xYOUR_PRIVATE_KEY_HERE"] // GANTI DENGAN PRIVATE KEY WALLET STG ANDA
    }
  }
};
