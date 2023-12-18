// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IERC20} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol';

contract Dex {
    address payable public owner;

    // Address for Aave DAI (aDAI) on Sepolia
    address private immutable daiAddress =
        0x29598b72eb5CeBd806C5dCD549490FdA35B13cD8;
    // Address for Aave USDC (aUSDC) on Sepolia
    address private immutable usdcAddress =
        0x16dA4541aD1807f4443d92D26044C1147406EB80;

    IERC20 private dai;
    IERC20 private usdc;

    // Exchange rates (DEMO).
    uint256 dexARate = 90;
    uint256 dexBRate = 100;

    // Keeps track of the individuals' dai balances.
    mapping(address => uint256) public daiBalances;

    // Keeps track of individuals' USDC balances.
    mapping(address => uint256) public usdcBalances;

    constructor() {
        owner = payable(msg.sender);
        dai = IERC20(daiAddress);
        usdc = IERC20(usdcAddress);
    }

    modifier onlyOwner() {
        // Requires that the caller's address is equal to the owner's adderess.
        require(
            msg.sender == owner,
            'Only the contract owner can call this function'
        );
        _;
    }

    /**
     * Description:
     * @param _amount The amount of USDC to send
     */
    function depositUSDC(uint256 _amount) external {
        // Mapping for wallets that deposit USDC.
        usdcBalances[msg.sender] += _amount;
        uint256 allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= _amount, 'Check the token allowance');
        usdc.transferFrom(msg.sender, address(this), _amount);
    }

    /**
     * Description:
     * @param _amount Amount of DAI to send.
     */
    function depositDAI(uint256 _amount) external {
        daiBalances[msg.sender] += _amount;
        uint256 allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= _amount, 'Check the token allowance');
        dai.transferFrom(msg.sender, address(this), _amount);
    }

    /**
     * Description: Buy DAI with USDC at dexA.
     */
    function buyDAI() external {
        // Take the balance of USDC and divide it by the exchange rate for dexA.
        // We are buying DAI with USDC.
        uint256 daiToRecieve = ((usdcBalances[msg.sender] / dexARate) * 100) *
            (10 ** 12);
        dai.transfer(msg.sender, daiToRecieve);
    }

    /**
     * Description: Sell DAI for USDC at dexB.
     */
    function sellDAI() external {
        // Have to format decimals between USDC & DAI. USDC used 6 while DAI uses 18.
        uint256 usdcToRecieve = ((daiBalances[msg.sender] * dexBRate) / 100) /
            (10 ** 12);
        usdc.transfer(msg.sender, usdcToRecieve);
    }

    /**
     * Description: Returns the balance of the contract's wallet for the specified token.
     * @param _tokenAddress Balance of the specified token in the contracts wallet.
     * @return Unsigned integer of the balance for the token.
     */
    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    /**
     * Description: Withdraw the balance of token from the contract's wallet to the function caller's wallet.
     *              With the modifier, only the owner can call this function.
     * @param _tokenAddress Address of the token to withdraw.
     */
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        // Transfer the token from the contract's wallet to the function caller (which only the owner is allowed).
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    /**
     * Description: Function that allows the contract to recieve ETH.
     */
    receive() external payable {}
    /**
     * Description:
     * @param
     * @return
     */
    /**
     * Description:
     * @param
     * @return
     */
    /**
     * Description:
     * @param
     * @return
     */
}
