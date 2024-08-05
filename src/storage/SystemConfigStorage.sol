// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {UpgradeableStorage} from "./UpgradeableStorage.sol";
import {ReferralInfo, MarketPlaceInfo} from "../interfaces/ISystemConfig.sol";

/**
 * @title SystemConfigStorage
 * @dev Storage of SystemConfig
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for SystemConfig.
 * @notice Total Storage Gaps: 100, UnUsed Storage Slots: 94.
 */

contract SystemConfigStorage is UpgradeableStorage {
    /// @dev base platform fee rate, default 0.05%
    uint256 public basePlatformFeeRate;

    /// @dev base referral rate, default 30% of platform fee
    uint256 public baseReferralRate;

    /// @dev user platform fee rate
    mapping(address => uint256) public userPlatformFeeRate;

    /// @dev user referral extra rate
    /// @notice baseReferralRate + extraReferralRate = referrerRate + authorReferralRate
    /// @dev referrerRate is the reward given to referrer
    /// @dev authorReferralRate is the reward given to trader
    mapping(address => uint256) public referralExtraRateMap;

    /// @dev user refferral info, detail see ReferralInfo.
    mapping(address => ReferralInfo) public referralInfoMap;

    /// @dev marketPlace info, detail see MarketPlaceInfo.
    mapping(address => MarketPlaceInfo) public marketPlaceInfoMap;

    /// @dev empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    /// start from slot 56, end at slot 149
    uint256[94] private __gap;
}
