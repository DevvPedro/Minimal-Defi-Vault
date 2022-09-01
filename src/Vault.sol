// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Vault_TransferFailed();
error Vault_NonZero();

contract Vault {
    IERC20 public immutable token;
    //Total shares to be increased anytime a share is minted
    uint256 public totalShares;

    event Deposit (address indexed _user, uint256 indexed _amount);
    event Withdrawal(address indexed _user, uint256 indexed _amount);
    event Mint(address indexed _user, uint256 indexed _amount);
    event Burn(address indexed _user, uint256 indexed _amount);

    constructor(IERC20 _token) {
        token = _token;
    }

    mapping(address => uint256) public shareBalance;

    /**
     * @notice deposits token into vault.
     * @notice mints shares, the share is calculated by dividing the product of the amount and shares by the token balance of the contract
     * @param amount | how much to deposit.
     */
    function deposit(uint256 amount) external {
        if(amount == 0) {
            revert Vault_NonZero();
        }
        uint shares;
        if (totalShares == 0) {
            shares = amount;
        }
        else {
            shares = (amount * totalShares)/ token.balanceOf(address(this));
        }

        mint(msg.sender, shares);

        bool success = token.transferFrom(msg.sender,address(this),amount);
        if(!success) {
            revert Vault_TransferFailed();
        }
        emit Deposit(msg.sender, amount);
    }
   /**
    * @notice withdraws shares
    *
    */
    function withdraw(uint256 amount) external {
        if(amount == 0) {
            revert Vault_NonZero();
        }
        uint shares = (amount * totalShares)/token.balanceOf(address(this));
        burn(msg.sender, shares);
        bool success = token.transfer(msg.sender, shares);
        if(!success) {
            revert Vault_TransferFailed();
        }
        emit Withdrawal(msg.sender, shares);
    }

    function mint(address user, uint256 amount) private {
        shareBalance[user] += amount;
        totalShares += amount;
        emit Mint(user,amount);
    }

    function burn(address user, uint256 amount) private {
        shareBalance[user] -= amount;
        totalShares -= amount;
        emit Burn(user,amount);
    }

}
