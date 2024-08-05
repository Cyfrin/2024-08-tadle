// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TokenManagerStorage} from "../storage/TokenManagerStorage.sol";
import {ITadleFactory} from "../factory/ITadleFactory.sol";
import {ITokenManager, TokenBalanceType} from "../interfaces/ITokenManager.sol";
import {ICapitalPool} from "../interfaces/ICapitalPool.sol";
import {IWrappedNativeToken} from "../interfaces/IWrappedNativeToken.sol";
import {RelatedContractLibraries} from "../libraries/RelatedContractLibraries.sol";
import {Rescuable} from "../utils/Rescuable.sol";
import {Related} from "../utils/Related.sol";
import {Errors} from "../utils/Errors.sol";

/**
 * @title TokenManager
 * @dev 1. Till in: Tansfer token from msg sender to capital pool
 *      2. Withdraw: Transfer token from capital pool to msg sender
 * @notice Only support ERC20 or native token
 * @notice Only support white listed token
 */
contract TokenManager is
    TokenManagerStorage,
    Rescuable,
    Related,
    ITokenManager
{
    constructor() Rescuable() {}

    modifier onlyInTokenWhiteList(bool _isPointToken, address _tokenAddress) {
        if (!_isPointToken && !tokenWhiteListed[_tokenAddress]) {
            revert TokenIsNotWhiteListed(_tokenAddress);
        }

        _;
    }

    /**
     * @notice Set wrapped native token
     * @dev Caller must be owner
     * @param _wrappedNativeToken Wrapped native token
     */
    function initialize(address _wrappedNativeToken) external onlyOwner {
        wrappedNativeToken = _wrappedNativeToken;
    }

    /**
     * @notice Till in, Transfer token from msg sender to capital pool
     * @param _accountAddress Account address
     * @param _tokenAddress Token address
     * @param _amount Transfer amount
     * @param _isPointToken The transfer token is pointToken
     * @notice Capital pool should be deployed
     * @dev Support ERC20 token and native token
     */
    function tillIn(
        address _accountAddress,
        address _tokenAddress,
        uint256 _amount,
        bool _isPointToken
    )
        external
        payable
        onlyRelatedContracts(tadleFactory, _msgSender())
        onlyInTokenWhiteList(_isPointToken, _tokenAddress)
    {
        /// @notice return if amount is 0
        if (_amount == 0) {
            return;
        }

        address capitalPoolAddr = tadleFactory.relatedContracts(
            RelatedContractLibraries.CAPITAL_POOL
        );
        if (capitalPoolAddr == address(0x0)) {
            revert Errors.ContractIsNotDeployed();
        }

        if (_tokenAddress == wrappedNativeToken) {
            /**
             * @dev token is native token
             * @notice check msg value
             * @dev if msg value is less than _amount, revert
             * @dev wrap native token and transfer to capital pool
             */
            if (msg.value < _amount) {
                revert Errors.NotEnoughMsgValue(msg.value, _amount);
            }
            IWrappedNativeToken(wrappedNativeToken).deposit{value: _amount}();
            _safe_transfer(wrappedNativeToken, capitalPoolAddr, _amount);
        } else {
            /// @notice token is ERC20 token
            _transfer(
                _tokenAddress,
                _accountAddress,
                capitalPoolAddr,
                _amount,
                capitalPoolAddr
            );
        }

        emit TillIn(_accountAddress, _tokenAddress, _amount, _isPointToken);
    }

    /**
     * @notice Add token balance
     * @dev Caller must be related contracts
     * @param _tokenBalanceType Token balance type
     * @param _accountAddress Account address
     * @param _tokenAddress Token address
     * @param _amount Claimable amount
     */
    function addTokenBalance(
        TokenBalanceType _tokenBalanceType,
        address _accountAddress,
        address _tokenAddress,
        uint256 _amount
    ) external onlyRelatedContracts(tadleFactory, _msgSender()) {
        userTokenBalanceMap[_accountAddress][_tokenAddress][
            _tokenBalanceType
        ] += _amount;

        emit AddTokenBalance(
            _accountAddress,
            _tokenAddress,
            _tokenBalanceType,
            _amount
        );
    }

    /**
     * @notice Withdraw
     * @dev Caller must be owner
     * @param _tokenAddress Token address
     * @param _tokenBalanceType Token balance type
     */
    function withdraw(
        address _tokenAddress,
        TokenBalanceType _tokenBalanceType
    ) external whenNotPaused {
        uint256 claimAbleAmount = userTokenBalanceMap[_msgSender()][
            _tokenAddress
        ][_tokenBalanceType];

        if (claimAbleAmount == 0) {
            return;
        }

        address capitalPoolAddr = tadleFactory.relatedContracts(
            RelatedContractLibraries.CAPITAL_POOL
        );

        if (_tokenAddress == wrappedNativeToken) {
            /**
             * @dev token is native token
             * @dev transfer from capital pool to msg sender
             * @dev withdraw native token to token manager contract
             * @dev transfer native token to msg sender
             */
            _transfer(
                wrappedNativeToken,
                capitalPoolAddr,
                address(this),
                claimAbleAmount,
                capitalPoolAddr
            );

            IWrappedNativeToken(wrappedNativeToken).withdraw(claimAbleAmount);
            payable(msg.sender).transfer(claimAbleAmount);
        } else {
            /**
             * @dev token is ERC20 token
             * @dev transfer from capital pool to msg sender
             */
            _safe_transfer_from(
                _tokenAddress,
                capitalPoolAddr,
                _msgSender(),
                claimAbleAmount
            );
        }

        emit Withdraw(
            _msgSender(),
            _tokenAddress,
            _tokenBalanceType,
            claimAbleAmount
        );
    }

    /**
     * @notice Update token white list
     * @dev Caller must be owner
     * @param _tokens Token addresses
     * @param _isWhiteListed Is white listed
     */
    function updateTokenWhiteListed(
        address[] calldata _tokens,
        bool _isWhiteListed
    ) external onlyOwner {
        uint256 _tokensLength = _tokens.length;

        for (uint256 i = 0; i < _tokensLength; ) {
            _updateTokenWhiteListed(_tokens[i], _isWhiteListed);
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Internal Function: Update token white list
     * @param _token Token address
     * @param _isWhiteListed Is white listed
     */
    function _updateTokenWhiteListed(
        address _token,
        bool _isWhiteListed
    ) internal {
        tokenWhiteListed[_token] = _isWhiteListed;

        emit UpdateTokenWhiteListed(_token, _isWhiteListed);
    }

    /**
     * @notice Internal Function: Transfer token
     * @dev Transfer ERC20 token
     * @param _token ERC20 token address
     * @param _from From address
     * @param _to To address
     * @param _amount Transfer amount
     */
    function _transfer(
        address _token,
        address _from,
        address _to,
        uint256 _amount,
        address _capitalPoolAddr
    ) internal {
        uint256 fromBalanceBef = IERC20(_token).balanceOf(_from);
        uint256 toBalanceBef = IERC20(_token).balanceOf(_to);

        if (
            _from == _capitalPoolAddr &&
            IERC20(_token).allowance(_from, address(this)) == 0x0
        ) {
            ICapitalPool(_capitalPoolAddr).approve(address(this));
        }

        _safe_transfer_from(_token, _from, _to, _amount);

        uint256 fromBalanceAft = IERC20(_token).balanceOf(_from);
        uint256 toBalanceAft = IERC20(_token).balanceOf(_to);

        if (fromBalanceAft != fromBalanceBef - _amount) {
            revert TransferFailed();
        }

        if (toBalanceAft != toBalanceBef + _amount) {
            revert TransferFailed();
        }
    }
}
