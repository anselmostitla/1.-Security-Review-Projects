// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// @audit-info the IThunderLoan should be implemented by the ThunderLoan contract

interface IThunderLoan {
    // @audit low/informational ?? is address token or ERC20 token
    function repay(address token, uint256 amount) external;
}
