// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title Rescuable
 * @dev An abstract contract that can be paused and unpaused.
 * @dev An abstract contract that can be rescued.
 */
contract Rescuable is Ownable, Pausable {
    bytes4 private constant TRANSFER_SELECTOR =
        bytes4(keccak256(bytes("transfer(address,uint256)")));
    bytes4 private constant TRANSFER_FROM_SELECTOR =
        bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));

    /// @dev Event emitted when the pause status is set
    event SetPauseStatus(bool status);

    /// @dev Event emitted when an account is rescued
    event Rescue(address to, address token, uint256 amount);

    /// @dev Error message when the transfer fails
    error TransferFailed();

    /// @dev Error message when the initialization fails
    error AlreadyInitialized();

    /// @notice Initializes the smart contract with the new implementation.
    constructor() Ownable(_msgSender()) {}

    function initializeOwnership(address _newOwner) external {
        if (owner() != address(0x0)) {
            revert AlreadyInitialized();
        }

        _transferOwnership(_newOwner);
    }

    /**
     * @notice The caller must be the owner.
     * @dev Sets the pause status.
     * @param pauseSatus The new pause status.
     */
    function setPauseStatus(bool pauseSatus) external onlyOwner {
        if (pauseSatus) {
            _pause();
        } else {
            _unpause();
        }

        emit SetPauseStatus(pauseSatus);
    }

    /**
     * @notice The caller must be the owner.
     * @dev Rescues an account.
     * @param to The address of the account to rescue.
     * @param token The token to rescue. If 0, it is ether.
     * @param amount The amount to rescue.
     * @notice The caller must be the owner.
     */
    function rescue(
        address to,
        address token,
        uint256 amount
    ) external onlyOwner {
        if (token == address(0x0)) {
            payable(to).transfer(amount);
        } else {
            _safe_transfer(token, to, amount);
        }

        emit Rescue(to, token, amount);
    }

    /**
     * @dev Safe transfer.
     * @param token The token to transfer. If 0, it is ether.
     * @param to The address of the account to transfer to.
     * @param amount The amount to transfer.
     */
    function _safe_transfer(
        address token,
        address to,
        uint256 amount
    ) internal {
        (bool success, ) = token.call(
            abi.encodeWithSelector(TRANSFER_SELECTOR, to, amount)
        );

        if (!success) {
            revert TransferFailed();
        }
    }

    /**
     * @dev Safe transfer.
     * @param token The token to transfer. If 0, it is ether.
     * @param to The address of the account to transfer to.
     * @param amount The amount to transfer.
     */
    function _safe_transfer_from(
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        (bool success, ) = token.call(
            abi.encodeWithSelector(TRANSFER_FROM_SELECTOR, from, to, amount)
        );

        if (!success) {
            revert TransferFailed();
        }
    }
}
