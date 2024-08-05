// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

// Upgradeable proxy contract used in OZ upgrades plugin
// @notice the version of OZ contracts is `5.0.2`
// @notice the first storage slot is used as admin
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {ITadleFactory} from "../factory/ITadleFactory.sol";
import {Errors} from "../utils/Errors.sol";

/**
 * @title UpgradeableProxy
 * @notice This contrct is based on TransparentUpgradeableProxy.
 * @dev This contrct serves as the proxy of SystemConfig, PreMarkets, DeliveryPlace, CapitalPool and TokenManager.
 * @notice the first storage slot is used as admin.
 * @notice the second storage slot is used as tadle factory.
 * @notice Total Storage Gaps: 50, UnUsed Storage Slots: 49.
 */
contract UpgradeableProxy is TransparentUpgradeableProxy {
    ITadleFactory public tadleFactory;

    /**
     * @param _logic address of logic contract
     * @param _admin address of admin
     * @param _data call data for logic
     */
    constructor(
        address _logic,
        address _admin,
        address _tadleFactory,
        bytes memory _data
    ) TransparentUpgradeableProxy(_logic, _admin, _data) {
        tadleFactory = ITadleFactory(_tadleFactory);
    }

    receive() external payable {}

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}
