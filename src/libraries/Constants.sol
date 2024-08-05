// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Constants
 * @dev Library of constants
 * @notice Add new constants here
 */
library Constants {
    /// @dev Platform fee decimal scaler
    uint256 internal constant PLATFORM_FEE_DECIMAL_SCALER = 1_000_000;

    /// @dev Each trade tax decimal scaler
    uint256 internal constant EACH_TRADE_TAX_DECIMAL_SCALER = 10_000;

    /// @dev Collateral rate decimal scaler
    uint256 internal constant COLLATERAL_RATE_DECIMAL_SCALER = 10_000;

    /// @dev Each trade tax maxinum
    uint256 internal constant EACH_TRADE_TAX_MAXINUM = 2000;

    /// @dev Referral rate decimal scaler
    uint256 internal constant REFERRAL_RATE_DECIMAL_SCALER = 1_000_000;

    /// @dev Referral base rate
    uint256 internal constant REFERRAL_BASE_RATE = 300_000;
}
