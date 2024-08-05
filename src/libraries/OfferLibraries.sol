// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/math/Math.sol";
import {OfferType} from "../interfaces/IPerMarkets.sol";
import {Constants} from "../libraries/Constants.sol";

/**
 * @title OfferLibraries
 * @dev Library of offer
 * @dev Get deposit amount
 * @dev Get refund amount
 */
library OfferLibraries {
    /**
     * @dev Get deposit amount
     * @dev if create ask offer, return _amount * _collateralRate;
     * @dev if create bid offer, return _amount;
     * @dev if create ask order, return _amount;
     * @dev if create bid order, return _amount * _collateralRate;
     * @param _offerType offer type
     * @param _collateralRate collateral rate
     * @param _amount amount
     * @param _isMaker is maker, true if create offer, false if create offer
     * @param _rounding rounding
     */
    function getDepositAmount(
        OfferType _offerType,
        uint256 _collateralRate,
        uint256 _amount,
        bool _isMaker,
        Math.Rounding _rounding
    ) internal pure returns (uint256) {
        /// @dev bid offer
        if (_offerType == OfferType.Bid && _isMaker) {
            return _amount;
        }

        /// @dev ask order
        if (_offerType == OfferType.Ask && !_isMaker) {
            return _amount;
        }

        return
            Math.mulDiv(
                _amount,
                _collateralRate,
                Constants.COLLATERAL_RATE_DECIMAL_SCALER,
                _rounding
            );
    }

    /**
     * @dev Get refund amount, offer type
     * @dev if close bid offer, return offer amount - used amount;
     * @dev if close ask offer, return (offer amount - used amount) * collateralRate;
     * @param _offerType offer type
     * @param _amount amount
     * @param _points points
     * @param _usedPoints used points
     * @param _collateralRate collateral rate
     */
    function getRefundAmount(
        OfferType _offerType,
        uint256 _amount,
        uint256 _points,
        uint256 _usedPoints,
        uint256 _collateralRate
    ) internal pure returns (uint256) {
        uint256 usedAmount = Math.mulDiv(
            _amount,
            _usedPoints,
            _points,
            Math.Rounding.Ceil
        );

        if (_offerType == OfferType.Bid) {
            return _amount - usedAmount;
        }

        return
            Math.mulDiv(
                _amount - usedAmount,
                _collateralRate,
                Constants.COLLATERAL_RATE_DECIMAL_SCALER,
                Math.Rounding.Floor
            );
    }
}
