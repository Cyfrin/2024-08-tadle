// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {SystemConfigStorage} from "../storage/SystemConfigStorage.sol";
import {ISystemConfig, ReferralInfo, MarketPlaceInfo, MarketPlaceStatus} from "../interfaces/ISystemConfig.sol";
import {Constants} from "../libraries/Constants.sol";
import {GenerateAddress} from "../libraries/GenerateAddress.sol";
import {Rescuable} from "../utils/Rescuable.sol";
import {Errors} from "../utils/Errors.sol";

/**
 * @title SystemConfig
 * @dev Contract of SystemConfig.
 * @dev Contains markets setting, referral setting, etc.
 */
contract SystemConfig is SystemConfigStorage, Rescuable, ISystemConfig {
    constructor() Rescuable() {}

    /**
     * @notice Set base platform fee rate and base referral rate
     * @dev Caller must be owner
     * @param _basePlatformFeeRate Base platform fee rate, default is 0.5%
     * @param _baseReferralRate Base referral rate, default is 30%
     */
    function initialize(
        uint256 _basePlatformFeeRate,
        uint256 _baseReferralRate
    ) external onlyOwner {
        basePlatformFeeRate = _basePlatformFeeRate;
        baseReferralRate = _baseReferralRate;
    }

    /**
     * @notice Update referrer setting
     * @param _referrer Referrer address
     * @param _referrerRate Referrer rate
     * @param _authorityRate Authority rate
     * @notice _referrerRate + _authorityRate = baseReferralRate + referralExtraRate
     * @notice _referrer != _msgSender()
     */
    function updateReferrerInfo(
        address _referrer,
        uint256 _referrerRate,
        uint256 _authorityRate
    ) external {
        if (_msgSender() == _referrer) {
            revert InvalidReferrer(_referrer);
        }

        if (_referrer == address(0x0)) {
            revert Errors.ZeroAddress();
        }

        if (_referrerRate < baseReferralRate) {
            revert InvalidReferrerRate(_referrerRate);
        }

        uint256 referralExtraRate = referralExtraRateMap[_referrer];
        uint256 totalRate = baseReferralRate + referralExtraRate;

        if (totalRate > Constants.REFERRAL_RATE_DECIMAL_SCALER) {
            revert InvalidTotalRate(totalRate);
        }

        if (_referrerRate + _authorityRate != totalRate) {
            revert InvalidRate(_referrerRate, _authorityRate, totalRate);
        }

        ReferralInfo storage referralInfo = referralInfoMap[_referrer];
        referralInfo.referrer = _referrer;
        referralInfo.referrerRate = _referrerRate;
        referralInfo.authorityRate = _authorityRate;

        emit UpdateReferrerInfo(
            msg.sender,
            _referrer,
            _referrerRate,
            _authorityRate
        );
    }

    /**
     * @notice Create market place
     * @param _marketPlaceName Market place name
     * @param _fixedratio Fixed ratio
     * @notice Caller must be owner
     * @notice _marketPlaceName must be unique
     * @notice _fixedratio is true if the market place is arbitration required
     */
    function createMarketPlace(
        string calldata _marketPlaceName,
        bool _fixedratio
    ) external onlyOwner {
        address marketPlace = GenerateAddress.generateMarketPlaceAddress(
            _marketPlaceName
        );
        MarketPlaceInfo storage marketPlaceInfo = marketPlaceInfoMap[
            marketPlace
        ];

        if (marketPlaceInfo.status != MarketPlaceStatus.UnInitialized) {
            revert MarketPlaceAlreadyInitialized();
        }

        marketPlaceInfo.status = MarketPlaceStatus.Online;
        marketPlaceInfo.fixedratio = _fixedratio;

        emit CreateMarketPlaceInfo(_marketPlaceName, marketPlace, _fixedratio);
    }

    /**
     * @notice Update market when settlement time is passed
     * @param _marketPlaceName Market place name
     * @param _tokenAddress Token address
     * @param _tokenPerPoint Token per point
     * @param _tge TGE
     * @param _settlementPeriod Settlement period
     * @notice Caller must be owner
     */
    function updateMarket(
        string calldata _marketPlaceName,
        address _tokenAddress,
        uint256 _tokenPerPoint,
        uint256 _tge,
        uint256 _settlementPeriod
    ) external onlyOwner {
        address marketPlace = GenerateAddress.generateMarketPlaceAddress(
            _marketPlaceName
        );

        MarketPlaceInfo storage marketPlaceInfo = marketPlaceInfoMap[
            marketPlace
        ];

        if (marketPlaceInfo.status != MarketPlaceStatus.Online) {
            revert MarketPlaceNotOnline(marketPlaceInfo.status);
        }

        marketPlaceInfo.tokenAddress = _tokenAddress;
        marketPlaceInfo.tokenPerPoint = _tokenPerPoint;
        marketPlaceInfo.tge = _tge;
        marketPlaceInfo.settlementPeriod = _settlementPeriod;

        emit UpdateMarket(
            _marketPlaceName,
            marketPlace,
            _tokenAddress,
            _tokenPerPoint,
            _tge,
            _settlementPeriod
        );
    }

    /**
     * @notice Update market place status
     * @param _marketPlaceName Market place name
     * @param _status Market place status
     * @notice Caller must be owner
     */
    function updateMarketPlaceStatus(
        string calldata _marketPlaceName,
        MarketPlaceStatus _status
    ) external onlyOwner {
        address marketPlace = GenerateAddress.generateMarketPlaceAddress(
            _marketPlaceName
        );
        MarketPlaceInfo storage marketPlaceInfo = marketPlaceInfoMap[
            marketPlace
        ];
        marketPlaceInfo.status = _status;
    }

    /**
     * @notice Update base platform fee rate
     * @param _accountAddress Account address
     * @param _platformFeeRate Platform fee rate of user
     * @notice Caller must be owner
     */
    function updateUserPlatformFeeRate(
        address _accountAddress,
        uint256 _platformFeeRate
    ) external onlyOwner {
        require(
            _platformFeeRate <= Constants.PLATFORM_FEE_DECIMAL_SCALER,
            "Invalid platform fee rate"
        );
        userPlatformFeeRate[_accountAddress] = _platformFeeRate;

        emit UpdateUserPlatformFeeRate(_accountAddress, _platformFeeRate);
    }

    /**
     * @notice Update referrer extra rate
     * @param _referrer Referrer address
     * @param _extraRate Extra rate
     * @notice Caller must be owner
     * @notice _extraRate + baseReferralRate <= REFERRAL_RATE_DECIMAL_SCALER
     */
    function updateReferralExtraRateMap(
        address _referrer,
        uint256 _extraRate
    ) external onlyOwner {
        uint256 totalRate = _extraRate + baseReferralRate;
        if (totalRate > Constants.REFERRAL_RATE_DECIMAL_SCALER) {
            revert InvalidTotalRate(totalRate);
        }
        referralExtraRateMap[_referrer] = _extraRate;
        emit UpdateReferralExtraRateMap(_referrer, _extraRate);
    }

    /// @dev Get base platform fee rate.
    function getBaseReferralRate() external view returns (uint256) {
        return baseReferralRate;
    }

    /**
     * @dev Get base platform fee rate.
     * @param _user address of user, create order by this user.
     */
    function getPlatformFeeRate(address _user) external view returns (uint256) {
        if (userPlatformFeeRate[_user] == 0) {
            return basePlatformFeeRate;
        }

        return userPlatformFeeRate[_user];
    }

    /// @dev Get referral info by referrer
    function getReferralInfo(
        address _referrer
    ) external view returns (ReferralInfo memory) {
        return referralInfoMap[_referrer];
    }

    /// @dev Get marketPlace info by marketPlace
    function getMarketPlaceInfo(
        address _marketPlace
    ) external view returns (MarketPlaceInfo memory) {
        return marketPlaceInfoMap[_marketPlace];
    }
}
