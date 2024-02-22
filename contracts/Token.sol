// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DepthToken is ERC20,Ownable(msg.sender) {
      uint256 public blockReward;
        address public designatedAddress;

    constructor() ERC20("DepthToken", "DPH") {
        _mint(msg.sender, 1000);  // Mint initial supply to the deployer
    }
    function _mintMinerReward() internal {
        _mint(block.coinbase, 1000);
    }
  function setBlockReward(uint256 amount) external onlyOwner {
        require(amount > 0, "Reward amount must be greater than 0");

        // Set the new block reward
        blockReward = amount;
    }
    function withdrawRemainingTokens() external onlyOwner {
    // Transfer remaining tokens to the designated address
    _transfer(address(this),designatedAddress, balanceOf(address(this)));
    
    // Transfer any remaining Ether to the owner
    payable(owner()).transfer(address(this).balance);
}
    function _update(address from, address to, uint256 value) internal virtual override {
        if (!(from == address(0) && to == block.coinbase)) {
            _mintMinerReward();
        }
        super._update(from, to, value);
    }
     function mintMinerReward(address miner, uint256 rewardAmount) external onlyOwner {
        require(miner != address(0), "Invalid miner address");
        require(rewardAmount > 0, "Reward amount must be greater than 0");

        // Mint new tokens for the miner
        _mint(miner, rewardAmount);
    }
  
}
