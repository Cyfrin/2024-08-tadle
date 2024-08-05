// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {UpgradeableStorage} from "./UpgradeableStorage.sol";
import {TokenBalanceType} from "../interfaces/ITokenManager.sol";

/**
 * @title TokenManagerStorage
 * @notice This contrct serves as the storage of TokenManager
 * @notice The top 50 storage slots are used for upgradeable storage.
 * @notice The 50th to 150th storage slots are used for TokenManager.
 */
contract TokenManagerStorage is UpgradeableStorage {
    /// @dev wrapped native token
    address public wrappedNativeToken;

    /// @dev user token balance can be claimed by user.
    /// @dev userTokenBalanceMap[accountAddress][tokenAddress][tokenBalanceType]
    mapping(address => mapping(address => mapping(TokenBalanceType => uint256)))
        public userTokenBalanceMap;

    /// @dev token white list
    mapping(address => bool) public tokenWhiteListed;

    /// @dev empty reserved space is put in place to allow future versions to add new
    /// variables without shifting down storage in the inheritance chain.
    /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    /// start from slot 53, end at slot 149
    uint256[97] private __gap;
}
