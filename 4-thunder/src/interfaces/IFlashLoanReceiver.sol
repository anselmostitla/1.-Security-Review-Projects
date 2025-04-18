// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.20;

// @audit info: unused import 
// it's bad practice to edit live code for tests/mock, we must remove the import from MockFlashLoanReceiver
import { IThunderLoan } from "./IThunderLoan.sol";

/**
 * @dev Inspired by Aave:
 * https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
 */
interface IFlashLoanReceiver {
    // q is the token, the token that's being borrowed?
    // @audit where the natspec?
    function executeOperation(
        address token,
        uint256 amount,
        uint256 fee,
        address initiator,
        bytes calldata params
    )
        external
        returns (bool);
}
