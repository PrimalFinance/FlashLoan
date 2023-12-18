const fs = require('fs');

const tokenListPath = './tokenList.js';

async function getTokenAddress(symbol, chainId) {
    const fileData = fs.readFile(tokenListPath);

    const tokenData = fileData[symbol];

    // If the token and chain are found.
    if (tokenData && tokenData.address && tokenData.address[chainId]) {
        return tokenData.address[chainId];
    } else {
        return null; // Token or chainId not found.
    }
}
