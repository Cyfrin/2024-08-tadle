// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @title ISystemConfig
 * @dev Interface of system config
 * @notice Add new system config here
 */
interface ISystemConfig {
    /// @dev Get base platform fee rate.
    function getBaseReferralRate() external view returns (uint256);

    /**
     * @dev Get base platform fee rate.
     * @param _user address of user, create order by this user.
     */
    function getPlatformFeeRate(address _user) external view returns (uint256);

    /// @dev Get referral info by referrer
    function getReferralInfo(
        address _referrer
    ) external view returns (ReferralInfo calldata);

    /// @dev Get marketPlace info by marketPlace
    function getMarketPlaceInfo(
        address _marketPlace
    ) external view returns (MarketPlaceInfo calldata);

    /// @dev Emit events when base platform fee rate is updated
    event UpdateBasePlatformFeeRate(uint256 basePlatformFeeRate);

    /// @dev Emit events when base referral rate is updated
    event UpdateBaseReferralRate(uint256 baseReferralRate);

    /// @dev Emit events when user platform fee rate is updated
    event UpdateUserPlatformFeeRate(
        address indexed userAddress,
        uint256 userPlatformFeeRate
    );

    /// @dev Emit events when user referral extra rate is updated
    event UpdateReferralExtraRate(
        address indexed referrerAddress,
        uint256 referrerRate
    );

    /// @dev Emit events when user referral extra rate is updated
    event UpdateReferrerExtraRate(
        address indexed authorityAddress,
        uint256 authorityRate
    );

    /// @dev Emit events when create marketPlace info
    event CreateMarketPlaceInfo(
        string indexed marketPlaceName,
        address indexed marketPlaceAddress,
        bool indexed fixedratio
    );

    /// @dev Emit events when update marketPlace info
    event UpdateMarket(
        string indexed marketPlaceName,
        address indexed marketPlaceAddress,
        address indexed tokenAddress,
        uint256 tokenPerPoint,
        uint256 tge,
        uint256 settlementPeriod
    );

    /// @dev Emit events when update referrer info
    event UpdateReferrerInfo(
        address indexed authorityAddress,
        address indexed referrerAddress,
        uint256 referrerRate,
        uint256 authorityRate
    );

    /// @dev Emit events when update referrer extra rate
    event UpdateReferralExtraRateMap(
        address indexed referrerAddress,
        uint256 referrerRate
    );

    /// Error when the referrer and the referee cannot be the same person
    error InvalidReferrer(address referrer);

    /// Error when invalid referrer rate or authority rate
    error InvalidRate(
        uint256 referrerRate,
        uint256 authorityRate,
        uint256 totalRate
    );

    /// Error when referrer rate must be greater than the base number
    error InvalidReferrerRate(uint256 referrerRate);

    /// Error when invalid total rate
    error InvalidTotalRate(uint256 totalRate);

    /// Error when invalid platform fee rate
    error InvalidPlatformFeeRate(uint256 platformFeeRate);

    /// Error when marketPlace already initialized
    error MarketPlaceAlreadyInitialized();

    /// Error when marketPlace is not online
    error MarketPlaceNotOnline(MarketPlaceStatus status);
}

/**
 * @title MarketPlaceStatus
 * @dev Enum of MarketPlaceStatus
 * @notice UnInitialized, Online, AskSettling, BidSettling, Offline
 * @param UnInitialized is the default value, when marketPlace is not created.
 * @param Online is the value when marketPlace is created and online.
 * @param AskSettling is the value when ask offer or ask order is settled.
 * @param BidSettling is the value when bid offer or bid order is settled.
 * @param Offline is the value when marketPlace is offline.
 */
enum MarketPlaceStatus {
    UnInitialized,
    Online,
    AskSettling,
    BidSettling,
    Offline
}

/**
 * @title MarketPlaceInfo
 * @dev Struct of MarketPlaceInfo
 * @notice fixedratio, status, tokenAddress, tokenPerPoint, tge, settlementPeriod
 * @param fixedratio maketPlace is fixedratio type or not
 * @param status marketPlace status, detail see MarketPlaceStatus
 * @param tokenAddress the point token address
 * @param tokenPerPoint token per point
 * @param tge Token Generation Even
 * @param settlementPeriod settlement period
 */
struct MarketPlaceInfo {
    bool fixedratio;
    MarketPlaceStatus status;
    address tokenAddress;
    uint256 tokenPerPoint;
    uint256 tge;
    uint256 settlementPeriod;
}

/**
 * @title ReferralInfo
 * @dev Struct of ReferralInfo
 * @notice referrer, referrerRate, authorityRate
 * @param referrer referrer address
 * @param referrerRate referrer rate
 * @param authorityRate authority rate
 */
struct ReferralInfo {
    address referrer;
    uint256 referrerRate;
    uint256 authorityRate;
}
