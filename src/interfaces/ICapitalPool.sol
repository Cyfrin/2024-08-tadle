// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @title ICapitalPool
 * @dev Interface of CapitalPool
 */
interface ICapitalPool {
    /**
     * @dev Approve token for token manager
     * @notice only can be called by token manager
     * @param tokenAddr address of token
     */
    function approve(address tokenAddr) external;

    /// @dev Error when approve failed
    error ApproveFailed();
}
