// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DepthToken
 * @dev ERC20 token with additional features including block reward, designated address, and miner rewards.
 */
contract DepthToken is ERC20,Ownable(msg.sender) {
      uint256 public blockReward;
        address public designatedAddress;
/**
     * @dev Constructor to initialize the DepthToken ERC20 token.
     */
    constructor() ERC20("DepthToken", "DPH") {
        _mint(msg.sender, 1000);  // Mint initial supply to the deployer
    }
    
    /**
     * @dev Internal function to mint miner rewards.
     */
    function _mintMinerReward() internal {
        _mint(block.coinbase, 1000);
    }
     /**
     * @dev Function to set the block reward, only callable by the owner.
     * @param amount The new block reward amount.
     */
  function setBlockReward(uint256 amount) external onlyOwner {
        require(amount > 0, "Reward amount must be greater than 0");

        // Set the new block reward
        blockReward = amount;
    }
      /**
     * @dev Function to withdraw remaining tokens, only callable by the owner.
     * Transfers remaining tokens to the designated address and any remaining Ether to the owner.
     */
    function withdrawRemainingTokens() external onlyOwner {
    // Transfer remaining tokens to the designated address
    _transfer(address(this),designatedAddress, balanceOf(address(this)));
    
    // Transfer any remaining Ether to the owner
    payable(owner()).transfer(address(this).balance);
}
    /**
     * @dev Internal function to update token balances, mints miner rewards if applicable.
     */

    function _update(address from, address to, uint256 value) internal virtual override {
        if (!(from == address(0) && to == block.coinbase)) {
            _mintMinerReward();
        }
        super._update(from, to, value);
    }
     /**
     * @dev Function to mint miner rewards, only callable by the owner.
     * @param miner The address of the miner to receive the rewards.
     * @param rewardAmount The amount of rewards to mint.
     */
     function mintMinerReward(address miner, uint256 rewardAmount) external onlyOwner {
        require(miner != address(0), "Invalid miner address");
        require(rewardAmount > 0, "Reward amount must be greater than 0");

        // Mint new tokens for the miner
        _mint(miner, rewardAmount);
    }
  
}
