// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

/**
 * @title GenerateAddress
 * @dev Library of generate address
 * @dev Generate address for maker, offer, stock and market place
 */
library GenerateAddress {
    /// @dev Generate address for maker address with id
    function generateMakerAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(_id, "maker")))));
    }

    /// @dev Generate address for offer address with id
    function generateOfferAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(_id, "offer")))));
    }

    /// @dev Generate address for stock address with id
    function generateStockAddress(uint256 _id) internal pure returns (address) {
        return address(uint160(uint256(keccak256(abi.encode(_id, "stock")))));
    }

    /// @dev Generate address for market place address with name
    function generateMarketPlaceAddress(
        string memory _marketPlaceName
    ) internal pure returns (address) {
        return
            address(uint160(uint256(keccak256(abi.encode(_marketPlaceName)))));
    }
}
