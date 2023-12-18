const hre = require('hardhat');

/** NOTES:
 * Find AAVE tokens here: https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses
 */

async function main() {
    const FlashLoan = await hre.ethers.getContractFactory('FlashLoan');
    // Deploy the flash loan contract.
    const flashLoan = await FlashLoan.deploy(
        /**
         * This address is the "PoolAddressesProvider" from AAVE for Sepolia.
         * The address can be found here: https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses
         * Passed to the constructor of the contract.
         */
        '0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A'
    );

    console.log('Flash loan contract deployed at: ', flashLoan.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

/**
 * Description:
 * @param
 * @returns
 */
/**
 * Description:
 * @param
 * @returns
 */
/**
 * Description:
 * @param
 * @returns
 */
/**
 * Description:
 * @param
 * @returns
 */
/**
 * Description:
 * @param
 * @returns
 */
/**
 * Description:
 * @param
 * @returns
 */

// 0xbDA5747bFD65F08deb54cb465eB87D40e51B197E
