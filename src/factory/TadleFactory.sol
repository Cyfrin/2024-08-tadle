// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
/// @dev Proxy admin contract used in OZ upgrades plugin
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

import {ITadleFactory} from "./ITadleFactory.sol";
import {Address} from "../libraries/Address.sol";
import {UpgradeableProxy} from "../proxy/UpgradeableProxy.sol";

/**
 * @title TadleFactory
 * @notice This contrct serves as the factory of Tadle.
 * @notice guardian address in constructor is a msig.
 */
contract TadleFactory is Context, ITadleFactory {
    using Address for address;

    /// @dev address of guardian, who can deploy some contracts
    address internal guardian;

    /**
     * @dev mapping of related contracts, deployed by factory
     *      1 => SystemConfig
     *      2 => PreMarkets
     *      3 => DeliveryPlace
     *      4 => CapitalPool
     *      5 => TokenManager
     */
    mapping(uint8 => address) public relatedContracts;

    modifier onlyGuardian() {
        if (_msgSender() != guardian) {
            revert CallerIsNotGuardian(guardian, _msgSender());
        }
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
    }

    /**
     * @notice deploy related contract
     * @dev guardian can deploy related contract
     * @param _relatedContractIndex index of related contract
     * @param _logic address of logic contract
     * @param _data call data for logic
     */
    function deployUpgradeableProxy(
        uint8 _relatedContractIndex,
        address _logic,
        bytes memory _data
    ) external onlyGuardian returns (address) {
        /// @dev the logic address must be a contract
        if (!_logic.isContract()) {
            revert LogicAddrIsNotContract(_logic);
        }

        /// @dev deploy proxy
        UpgradeableProxy _proxy = new UpgradeableProxy(
            _logic,
            guardian,
            address(this),
            _data
        );
        relatedContracts[_relatedContractIndex] = address(_proxy);
        emit RelatedContractDeployed(_relatedContractIndex, address(_proxy));
        return address(_proxy);
    }
}
