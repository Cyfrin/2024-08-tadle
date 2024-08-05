// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {MarketPlaceInfo, MarketPlaceStatus} from "../interfaces/ISystemConfig.sol";

/**
 * @title MarketPlaceLibraries
 * @dev Library of market place
 * @dev Get status of market place
 * @dev Check status of market place
 */
library MarketPlaceLibraries {
    /**
     * @dev Get status of market place
     * @param _blockTimestamp block timestamp
     * @param _marketPlaceInfo market place info
     * @dev block timestamp is larger than tge + settlementPeriod, return BidSettling
     * @dev block timestamp is larger than tge, return AskSettling
     */
    function getMarketPlaceStatus(
        uint256 _blockTimestamp,
        MarketPlaceInfo memory _marketPlaceInfo
    ) internal pure returns (MarketPlaceStatus _status) {
        if (_marketPlaceInfo.status == MarketPlaceStatus.Offline) {
            return MarketPlaceStatus.Offline;
        }

        /// @dev settle not active
        if (_marketPlaceInfo.tge == 0) {
            return _marketPlaceInfo.status;
        }

        if (
            _blockTimestamp >
            _marketPlaceInfo.tge + _marketPlaceInfo.settlementPeriod
        ) {
            return MarketPlaceStatus.BidSettling;
        }

        if (_blockTimestamp > _marketPlaceInfo.tge) {
            return MarketPlaceStatus.AskSettling;
        }

        return _marketPlaceInfo.status;
    }

    /**
     * @dev Check status of market place
     * @param _blockTimestamp block timestamp
     * @param _marketPlaceInfo market place info
     * @param _status status
     * @dev true if market status == _status
     */
    function checkMarketPlaceStatus(
        MarketPlaceInfo memory _marketPlaceInfo,
        uint256 _blockTimestamp,
        MarketPlaceStatus _status
    ) internal pure {
        MarketPlaceStatus status = getMarketPlaceStatus(
            _blockTimestamp,
            _marketPlaceInfo
        );

        if (status != _status) {
            revert("Mismatched Marketplace status");
        }
    }
}
