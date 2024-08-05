// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {CapitalPoolStorage} from "../storage/CapitalPoolStorage.sol";
import {ICapitalPool} from "../interfaces/ICapitalPool.sol";
import {RelatedContractLibraries} from "../libraries/RelatedContractLibraries.sol";
import {Rescuable} from "../utils/Rescuable.sol";

/**
 * @title CapitalPool
 * @notice Implement the capital pool
 */
contract CapitalPool is CapitalPoolStorage, Rescuable, ICapitalPool {
    bytes4 private constant APPROVE_SELECTOR =
        bytes4(keccak256(bytes("approve(address,uint256)")));

    constructor() Rescuable() {}

    /**
     * @dev Approve token for token manager
     * @notice only can be called by token manager
     * @param tokenAddr address of token
     */
    function approve(address tokenAddr) external {
        address tokenManager = tadleFactory.relatedContracts(
            RelatedContractLibraries.TOKEN_MANAGER
        );
        (bool success, ) = tokenAddr.call(
            abi.encodeWithSelector(
                APPROVE_SELECTOR,
                tokenManager,
                type(uint256).max
            )
        );

        if (!success) {
            revert ApproveFailed();
        }
    }
}
