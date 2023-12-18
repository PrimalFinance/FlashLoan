// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// AAVE imports
import {FlashLoanSimpleReceiverBase} from '@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol';
import {IPoolAddressesProvider} from '@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol';
import {IERC20} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol';

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(
        address _addressProvider
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        // Set the owner to the deployer of the contract.
        owner = payable(msg.sender);
    }

    // Modifier where only the contract owner can access/call a function.
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            'Only the contract owner can call this function'
        );
        _;
    }

    /**
     * Description:
     * @notice Executes an operation after receiving hte flash-borrowed asset.
     * @dev Ensure that the contract can return the debt + premium, e.g., has enough funds
     *      to repay and has approved the Pool to pull the total amount.
     *
     * @param asset The address of the flash-borrowed asset
     * @param amount The amount of the flash-borrowed asset
     * @param premium Fee of the flash-borrowed assets
     * @param initiator The address of the flashloan initiator
     * @param params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(
        address asset, // Asset being borrowed
        uint256 amount, // Amount to borrow
        uint256 premium, // Premium for the loan
        address initiator, // Address of the flash loan initiator
        bytes calldata params // The byte-encoded parmas passed when initiating the flashloan.
    ) external override returns (bool) {
        // At this point we should have the borrowed funds.

        uint256 amountOwed = amount + premium;
        // Approve the amount of tokens equivalent to the amount owed.
        IERC20(asset).approve(address(POOL), amountOwed);
        // NOTE: The pool variable is not declared in this contract, but in "FlashLoanSimpleReceiverBase.sol"

        return true;
    }

    /**
     * Description:
     * @param _token: Address of the token to borrow.
     * @param _amount: Amount of the token to borrow.
     */
    function requestFlashLoan(address _token, uint256 _amount) public {
        // Set the reciever address of the flash loan to this contract.
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        // Set these to default parameters.
        bytes memory params = '';
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    /**
     * Description: Get the balance of the token in the contract's wallet.
     * @param _tokenAddress Address of the token to check the balance for.
     * @return uint256 of the balance for the token.
     */
    function getBalance(address _tokenAddress) external view returns (uint256) {
        // Return the balance of the token in this contracts wallet.
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    /**
     * Description: Withdraw the balance of a token to the contract owners wallet.
     * @param _tokenAddress The address of the token to withdraw.
     */
    function withdraw(address _tokenAddress) external {
        // Create variable for the token we want to withdraw.
        IERC20 token = IERC20(_tokenAddress);
        // Transfer the entire balance of the token to the function caller (which only the onwer should be able to call).
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    /**
     * Description: Allow the function to recieve Ether.
     */
    receive() external payable {}
}
