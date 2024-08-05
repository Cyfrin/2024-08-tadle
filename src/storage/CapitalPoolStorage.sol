// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {UpgradeableStorage} from "./UpgradeableStorage.sol";

/**
 * @title CapitalPoolStorage
 * @notice This contrct serves as the storage of CapitalPool
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for CapitalPool.
 */
contract CapitalPoolStorage is UpgradeableStorage {
    /// @dev empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    /// start from slot 50, end at slot 149
    uint256[100] private __gap;
}
