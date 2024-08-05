// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {OfferStatus, AbortOfferStatus, OfferType, OfferSettleType} from "../storage/OfferStatus.sol";
import {StockStatus, StockType} from "../storage/OfferStatus.sol";

/**
 * @title IPerMarkets
 * @dev Interface of PerMarkets
 */
interface IPerMarkets {
    /**
     * @dev Get offer info by offer address
     * @param _offer offer address
     */
    function getOfferInfo(
        address _offer
    ) external view returns (OfferInfo memory _offerInfo);

    /**
     * @dev Get stock info by stock address
     * @param _stock stock address
     */
    function getStockInfo(
        address _stock
    ) external view returns (StockInfo memory _stockInfo);

    /**
     * @dev Get maker info by maker address
     * @param _maker maker address
     */
    function getMakerInfo(
        address _maker
    ) external view returns (MakerInfo memory _makerInfo);

    /**
     * @dev Update offer status
     * @notice Only called by DeliveryPlace
     * @param _offer offer address
     * @param _status new status
     */
    function updateOfferStatus(address _offer, OfferStatus _status) external;

    /**
     * @dev Update stock status
     * @notice Only called by DeliveryPlace
     * @param _stock stock address
     * @param _status new status
     */
    function updateStockStatus(address _stock, StockStatus _status) external;

    /**
     * @dev Settled ask offer
     * @notice Only called by DeliveryPlace
     * @param _offer offer address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     */
    function settledAskOffer(
        address _offer,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    ) external;

    /**
     * @dev Settle ask taker
     * @notice Only called by DeliveryPlace
     * @param _offer offer address
     * @param _stock stock address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     */
    function settleAskTaker(
        address _offer,
        address _stock,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    ) external;

    /// @dev Event when offer created
    event CreateOffer(
        address indexed _offer,
        address indexed _maker,
        address indexed _stock,
        address _marketPlace,
        address _authority,
        uint256 _points,
        uint256 _amount
    );

    /// @dev Event when taker created
    event CreateTaker(
        address indexed offer,
        address authority,
        address stock,
        uint256 points,
        uint256 amount,
        uint256 tradeTax,
        uint256 platformFee
    );

    /// @dev Event when referrer updated
    event ReferralBonus(
        address indexed stock,
        address authority,
        address referrer,
        uint256 authorityReferralBonus,
        uint256 referrerReferralBonus,
        uint256 tradingVolume,
        uint256 tradingFee
    );

    /// @dev Event when offer listed
    event ListOffer(
        address indexed offer,
        address indexed stock,
        address authority,
        uint256 points,
        uint256 amount
    );

    /// @dev Event when offer closed
    event CloseOffer(address indexed offer, address indexed authority);

    /// @dev Event when offer relisted
    event RelistOffer(address indexed offer, address indexed authority);

    /// @dev Event when offer aborted
    event AbortAskOffer(address indexed offer, address indexed authority);

    /// @dev Event when taker aborted
    event AbortBidTaker(address indexed stock, address indexed authority);

    /// @dev Event when offer status updated
    event OfferStatusUpdated(address _offer, OfferStatus _status);

    /// @dev Event when stock status updated
    event StockStatusUpdated(address _stock, StockStatus _status);

    /// @dev Event when ask offer settled
    event SettledAskOffer(
        address _offer,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    );

    /// @dev Event when ask taker settled
    event SettledBidTaker(
        address _offer,
        address _stock,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount
    );

    /// @dev Error when invalid each trade tax rate
    error InvalidEachTradeTaxRate();

    /// @dev Error when invalid collateral rate
    error InvalidCollateralRate();

    /// @dev Error when invalid offer account
    error InvalidOfferAccount(address _targetAccount, address _currentAccount);

    /// @dev Error when maker is already exist
    error MakerAlreadyExist();

    /// @dev Error when offer is already exist
    error OfferAlreadyExist();

    /// @dev Error when stock is already exist
    error StockAlreadyExist();

    /// @dev Error when invalid offer
    error InvalidOffer();

    /// @dev Error when invalid offer type
    error InvalidOfferType(OfferType _targetType, OfferType _currentType);

    /// @dev Error when invalid stock status
    error InvalidStockType(StockType _targetType, StockType _currentType);

    /// @dev Error when invalid offer status
    error InvalidOfferStatus();

    /// @dev Error when invalid offer status
    error InvalidAbortOfferStatus(
        AbortOfferStatus _targetStatus,
        AbortOfferStatus _currentStatus
    );

    /// @dev Error when invalid stock status
    error InvalidStockStatus(
        StockStatus _targetStatus,
        StockStatus _currentStatus
    );

    /// @dev Error when not enough points
    error NotEnoughPoints(
        uint256 _totalPoints,
        uint256 _usedPoints,
        uint256 _points
    );
}

/**
 * @title MakerInfo
 * @dev Struct of MakerInfo
 * @notice offerSettleType, authority, marketPlace, tokenAddress, originOffer, platformFee, eachTradeTax
 * @param offerSettleType the settle type of offer.
 * @param authority the owner of maker, same as the authority of originOffer.
 * @param marketPlace the marketPlace of maker.
 */
struct MakerInfo {
    OfferSettleType offerSettleType;
    address authority;
    address marketPlace;
    address tokenAddress;
    address originOffer;
    uint256 platformFee;
    uint256 eachTradeTax;
}

/**
 * @title OfferInfo
 * @dev Struct of OfferInfo
 * @param id the unique id of offer.
 * @param authority the owner of offer.
 * @param maker the maker of offer, is a virtual address, storage as MakerInfo.
 * @param offerStatus the status of offer, detail in OfferStatus.sol.
 * @param offerType the type of offer, detail in OfferStatus.sol.
 * @param abortOfferStatus the status of abort offer, detail in OfferStatus.sol.
 * @param points the points of sell or buy offer.
 * @param amount the amount want to sell or buy.
 * @param collateralRate the collateral rate of offer. must be greater than 100%. decimal is 10000.
 * @param usedPoints the points that already completed.
 * @param tradeTax the trade tax of offer. decimal is 10000.
 * @param settledPoints the settled points of offer.
 * @param settledPointTokenAmount the settled point token amount of offer.
 * @param settledCollateralAmount the settled collateral amount of offer.
 */
struct OfferInfo {
    uint256 id;
    address authority;
    address maker;
    OfferStatus offerStatus;
    OfferType offerType;
    AbortOfferStatus abortOfferStatus;
    uint256 points;
    uint256 amount;
    uint256 collateralRate;
    uint256 usedPoints;
    uint256 tradeTax;
    uint256 settledPoints;
    uint256 settledPointTokenAmount;
    uint256 settledCollateralAmount;
}

/**
 * @title StockInfo
 * @dev Struct of StockInfo
 * @notice id, stockStatus, stockType, authority, maker, preOffer, points, amount, offer
 * @param id the unique id of stock.
 * @param stockStatus the status of stock, detail in OfferStatus.sol.
 * @param stockType the type of stock, detail in OfferStatus.sol.
 * @param authority the owner of stock.
 * @param maker the maker of stock, is a virtual address, storage as MakerInfo.
 * @param preOffer the preOffer of stock.
 * @param points the points of sell or buy stock.
 * @param amount receive or used collateral amount when sell or buy.
 * @param offer the offer of stock, is a virtual address, storage as OfferInfo.
 */
struct StockInfo {
    uint256 id;
    StockStatus stockStatus;
    StockType stockType;
    address authority;
    address maker;
    address preOffer;
    uint256 points;
    uint256 amount;
    address offer;
}

/**
 * @title CreateOfferParams
 * @dev Struct of CreateOfferParams
 * @notice marketPlace, tokenAddress, points, amount, collateralRate, eachTradeTax, offerType, offerSettleType
 * @param marketPlace the marketPlace of offer.
 * @param tokenAddress the collateral token address of offer.
 * @param points the points of sell or buy offer.
 * @param amount the amount want to sell or buy.
 * @param collateralRate the collateral rate of offer. must be greater than 100%. decimal is 10000.
 * @param eachTradeTax the trade tax of offer. decimal is 10000.
 * @param offerType the type of offer, detail in OfferType.sol.
 * @param offerSettleType the settle type of offer, detail in OfferSettleType.sol.
 */
struct CreateOfferParams {
    address marketPlace;
    address tokenAddress;
    uint256 points;
    uint256 amount;
    uint256 collateralRate;
    uint256 eachTradeTax;
    OfferType offerType;
    OfferSettleType offerSettleType;
}
