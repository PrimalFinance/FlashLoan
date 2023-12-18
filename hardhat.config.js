require('dotenv').config();
require('@nomicfoundation/hardhat-toolbox');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: '0.8.10',
    defaultNetwork: 'hardhat',
    networks: {
        hardhat: {
            chainId: 31337,
            forking: {
                url: process.env.INFURA_ETHEREUM_URL,
            },
        },
        sepolia: {
            url: process.env.INFURA_SEPOLIA_URL,
            accounts: [process.env.TEST_PRIVATE_KEY],
        },
    },
};
