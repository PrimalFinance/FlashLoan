const hre = require('hardhat');

async function main() {
    console.log('[Dex] deploying...');
    // Get the "contract factory" for the "Dex" contract.
    const Dex = await hre.ethers.getContractFactory('Dex');
    // Deploy the contract.
    const dex = await Dex.deploy();

    console.log('Dex contract deployed: ', dex.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
