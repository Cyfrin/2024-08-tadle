// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {OfferType} from "../storage/OfferStatus.sol";

/**
 * @title IDeliveryPlace
 * @dev Interface of DeliveryPlace
 */
interface IDeliveryPlace {
    /**
     * @dev Emit events when close bid offer
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _offer offer address
     * @param _authority authority address
     */
    event CloseBidOffer(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _offer,
        address _authority
    );

    /**
     * @dev Emit events when close bid taker
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _stock stock address
     * @param _authority authority address
     * @param _userCollateralFee user collateral fee
     * @param _pointTokenAmount point token amount
     */
    event CloseBidTaker(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _stock,
        address _authority,
        uint256 _userCollateralFee,
        uint256 _pointTokenAmount
    );

    /**
     * @dev Emit events when settle ask maker
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _offer offer address
     * @param _authority authority address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     * @param _makerRefundAmount maker refund amount
     */
    event SettleAskMaker(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _offer,
        address _authority,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount,
        uint256 _makerRefundAmount
    );

    /**
     * @dev Emit events when settle ask taker
     * @param _marketPlace market place address
     * @param _maker maker address
     * @param _stock stock address
     * @param _preOffer pre offer address
     * @param _authority authority address
     * @param _settledPoints settled points
     * @param _settledPointTokenAmount settled point token amount
     * @param _collateralFee collateral fee
     */
    event SettleAskTaker(
        address indexed _marketPlace,
        address indexed _maker,
        address indexed _stock,
        address _preOffer,
        address _authority,
        uint256 _settledPoints,
        uint256 _settledPointTokenAmount,
        uint256 _collateralFee
    );

    /// @dev Error when invalid offer type
    error InvalidOfferType(OfferType _targetType, OfferType _currentType);

    /// @dev Error when invalid offer status
    error InvalidOfferStatus();

    /// @dev Error when invalid stock status
    error InvalidStockStatus();

    /// @dev Error when invalid market place status
    error InvaildMarketPlaceStatus();

    /// @dev Error when invalid stock
    error InvalidStock();

    /// @dev Error when invalid stock type
    error InvalidStockType();

    /// @dev Error when insufficient remaining points
    error InsufficientRemainingPoints();

    /// @dev Error when invalid points
    error InvalidPoints();

    /// @dev Error when fixed ratio unsupported
    error FixedRatioUnsupported();
}
