// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {UpgradeableStorage} from "./UpgradeableStorage.sol";

import {OfferStatus} from "./OfferStatus.sol";
import {OfferInfo, StockInfo, MakerInfo} from "../interfaces/IPerMarkets.sol";

/**
 * @title PerMarketsStorage
 * @notice This contrct serves as the storage of PerMarkets
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for PerMarkets.
 */
contract PerMarketsStorage is UpgradeableStorage {
    /// @dev the last offer id. increment by 1
    /// @notice the storage slot is 50
    uint256 public offerId;

    /// @dev offer account => offer info.
    /// @notice the storage slot is 51
    mapping(address => OfferInfo) public offerInfoMap;

    /// @dev stock account => stock info.
    /// @notice the storage slot is 52
    mapping(address => StockInfo) public stockInfoMap;

    /// @dev maker account => maker info.
    /// @notice the storage slot is 53
    mapping(address => MakerInfo) public makerInfoMap;

    /// @dev empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    /// start from slot 54, end at slot 149
    uint256[96] private __gap;
}
