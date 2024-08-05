// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20Token is ERC20 {
    constructor() ERC20("MockToken", "MT") {}
}
