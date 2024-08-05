// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `target` is a contract.
     */
    function isContract(address target) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(target)
        }
        return size > 0;
    }
}
