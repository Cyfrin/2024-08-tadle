// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {ITadleFactory} from "../factory/ITadleFactory.sol";
import {RelatedContractLibraries} from "../libraries/RelatedContractLibraries.sol";

/**
 * @title Related
 * @dev Class of related contract
 * @notice Add new related contract here
 */
contract Related {
    /// @dev Error when caller is not related contracts
    error CallerIsNotRelatedContracts(address);

    /// @dev Error when caller is not delivery place
    error CallerIsNotDeliveryPlace();

    /// @dev check caller is related contracts
    modifier onlyRelatedContracts(
        ITadleFactory _tadleFactory,
        address _msgSender
    ) {
        /// @dev check caller is pre markets or delivery place
        address preMarketsAddr = _tadleFactory.relatedContracts(
            RelatedContractLibraries.PRE_MARKETS
        );
        address deliveryPlaceAddr = _tadleFactory.relatedContracts(
            RelatedContractLibraries.DELIVERY_PLACE
        );

        if (_msgSender != preMarketsAddr && _msgSender != deliveryPlaceAddr) {
            revert CallerIsNotRelatedContracts(_msgSender);
        }

        _;
    }

    modifier onlyDeliveryPlace(
        ITadleFactory _tadleFactory,
        address _msgSender
    ) {
        address deliveryPlaceAddr = _tadleFactory.relatedContracts(
            RelatedContractLibraries.DELIVERY_PLACE
        );

        if (_msgSender != deliveryPlaceAddr) {
            revert CallerIsNotDeliveryPlace();
        }
        _;
    }
}
