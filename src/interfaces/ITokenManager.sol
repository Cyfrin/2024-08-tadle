// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @title ITokenManager
 * @dev Interface of TokenManager
 */
interface ITokenManager {
    /**
     * @dev Till in, token from user to capital pool
     * @param accountAddress user address
     * @param tokenAddress token address
     * @param amount amount of token
     * @param isPointToken is point token
     */
    function tillIn(
        address accountAddress,
        address tokenAddress,
        uint256 amount,
        bool isPointToken
    ) external payable;

    /**
     * @dev Add token balance
     * @param tokenBalanceType token balance type
     * @param accountAddress user address
     * @param tokenAddress token address
     * @param amount the claimable amount of token
     */
    function addTokenBalance(
        TokenBalanceType tokenBalanceType,
        address accountAddress,
        address tokenAddress,
        uint256 amount
    ) external;

    /// @dev Emit events when till in
    event TillIn(
        address indexed accountAddress,
        address indexed tokenAddress,
        uint256 amount,
        bool isPointToken
    );

    /// @dev Emit events when add token balance
    event AddTokenBalance(
        address indexed accountAddress,
        address indexed tokenAddress,
        TokenBalanceType indexed tokenBalanceType,
        uint256 amount
    );

    /// @dev Emit events when withdraw
    event Withdraw(
        address indexed authority,
        address indexed tokenAddress,
        TokenBalanceType indexed tokenBalanceType,
        uint256 amount
    );

    /// @dev Emit events when update token white list
    event UpdateTokenWhiteListed(
        address indexed tokenAddress,
        bool isWhiteListed
    );

    /// @dev Error when token is not whitelisted
    error TokenIsNotWhiteListed(address tokenAddress);
}

/**
 * @notice TokenBalanceType
 * @dev Token balance type
 * @param TaxIncome: tax income
 * @param ReferralBonus: referral bonus
 * @param SalesRevenue: sales revenue
 * @param RemainingCash: remaining cash
 * @param MakerRefund: maker refund
 * @param PointToken: balance of point token
 */
enum TokenBalanceType {
    TaxIncome,
    ReferralBonus,
    SalesRevenue,
    RemainingCash,
    MakerRefund,
    PointToken
}
