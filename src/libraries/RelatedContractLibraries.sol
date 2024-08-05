// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {ITadleFactory} from "../factory/ITadleFactory.sol";
import {ISystemConfig} from "../interfaces/ISystemConfig.sol";
import {IPerMarkets} from "../interfaces/IPerMarkets.sol";
import {IDeliveryPlace} from "../interfaces/IDeliveryPlace.sol";
import {ICapitalPool} from "../interfaces/ICapitalPool.sol";
import {ITokenManager} from "../interfaces/ITokenManager.sol";

/**
 * @title RelatedContractLibraries
 * @dev Library of related contracts
 * @dev Get interface of related contract from TadleFactory
 * @notice Add new related contract here
 */
library RelatedContractLibraries {
    uint8 internal constant SYSTEM_CONFIG = 1;
    uint8 internal constant PRE_MARKETS = 2;
    uint8 internal constant DELIVERY_PLACE = 3;
    uint8 internal constant CAPITAL_POOL = 4;
    uint8 internal constant TOKEN_MANAGER = 5;

    
    /// @dev Get interface of system config
    function getSystemConfig(
        ITadleFactory _tadleFactory
    ) internal view returns (ISystemConfig) {
        return ISystemConfig(_tadleFactory.relatedContracts(SYSTEM_CONFIG));
    }

    /// @dev Get interface of per markets
    function getPerMarkets(
        ITadleFactory _tadleFactory
    ) internal view returns (IPerMarkets) {
        return IPerMarkets(_tadleFactory.relatedContracts(PRE_MARKETS));
    }

    /// @dev Get interface of delivery place
    function getDeliveryPlace(
        ITadleFactory _tadleFactory
    ) internal view returns (IDeliveryPlace) {
        return IDeliveryPlace(_tadleFactory.relatedContracts(DELIVERY_PLACE));
    }

    /// @dev Get interface of capital pool
    function getCapitalPool(
        ITadleFactory _tadleFactory
    ) internal view returns (ICapitalPool) {
        return ICapitalPool(_tadleFactory.relatedContracts(CAPITAL_POOL));
    }

    /// @dev Get interface of token manager
    function getTokenManager(
        ITadleFactory _tadleFactory
    ) internal view returns (ITokenManager) {
        return ITokenManager(_tadleFactory.relatedContracts(TOKEN_MANAGER));
    }
}
