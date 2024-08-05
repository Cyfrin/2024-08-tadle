// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @title IWrappedNativeToken
 * @dev Interface of WrappedNativeToken, such as WETH
 */
interface IWrappedNativeToken {
    /**
     * @dev Deposit WrappedNativeToken
     * @dev transfer native token to this contract and get WETH
     */
    function deposit() external payable;

    /**
     * @dev Withdraw WrappedNativeToken
     * @dev transfer WETH to native token
     * @param wad amount of WETH
     */
    function withdraw(uint256 wad) external;
}
