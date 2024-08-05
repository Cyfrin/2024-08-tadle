// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @dev Offer status
 * @notice Unknown, Virgin, Ongoing, Canceled, Filled, Settling, Settled
 * @param Unknown offer not yet exist.
 * @param Virgin offer has been listed, but not one trade.
 * @param Ongoing offer has been listed, and already one trade.
 * @param Canceled offer has been canceled.
 * @param Filled offer has been filled.
 * @param Settling offer is settling.
 * @param Settled offer has been settled, the last status.
 */
enum OfferStatus {
    Unknown,
    Virgin,
    Ongoing,
    Canceled,
    Filled,
    Settling,
    Settled
}

/**
 * @dev Offer type
 * @notice Ask, Bid
 * @param Ask create offer to sell points
 * @param Bid create offer to buy points
 */
enum OfferType {
    Ask,
    Bid
}

/**
 * @dev Stock type
 * @notice Ask, Bid
 * @param Ask create order to sell points
 * @param Bid create order to buy points
 */
enum StockType {
    Ask,
    Bid
}

/**
 * @dev Stock status
 * @notice Unknown, Initialized, Finished
 * @param Unknown order not yet exist.
 * @param Initialized order already exist
 * @param Finished order already finished
 */
enum StockStatus {
    Unknown,
    Initialized,
    Finished
}

/**
 * @dev Offer settle type
 * @notice Protected, Turbo
 * @param Protected offer type is protected
 * @param Turbo offer type is turbo
 */
enum OfferSettleType {
    Protected,
    Turbo
}

/**
 * @dev Abort offer status
 * @notice Initialized, SubOfferListed, Aborted
 * @param Initialized offer not yet exist.
 * @param SubOfferListed some one trade, and relist the offer
 * @param Aborted order has been aborted
 */
enum AbortOfferStatus {
    Initialized,
    SubOfferListed,
    Aborted
}
