// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

interface ITadleFactory {
    /// @dev get related contract address by index
    function relatedContracts(uint8 _index) external view returns (address);

    /// @dev Emit event when proxy admin is deployed
    event ProxyAdminDeployed(address _proxyAdmin);

    /// @dev Emit event when related contract is deployed
    /// @param _index index of related contract
    /// @param _contractAddr address of related contract
    event RelatedContractDeployed(uint256 _index, address _contractAddr);

    /// @dev Error when caller is not guardian
    error CallerIsNotGuardian(address _guardian, address _msgSender);

    /// @dev Error when proxy admin is not deployed
    error UnDepoloyedProxyAdmin();

    /// @dev Error when logic address is not a contract
    error LogicAddrIsNotContract(address _logic);
}
