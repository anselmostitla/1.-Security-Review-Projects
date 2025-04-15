// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { MockTSwapPool } from "./MockTSwapPool.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";

contract MockPoolFactory {
    error PoolFactory__PoolAlreadyExists(address tokenAddress);
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    mapping(address token => address pool) private s_pools; // q a mapping by default is in storage, so it is not needed to prefix each mapping variable with s indicating storage
    mapping(address pool => address token) private s_tokens;

    function createPool(address tokenAddress) external returns (address) {
        if (s_pools[tokenAddress] != address(0)) {
            revert PoolFactory__PoolAlreadyExists(tokenAddress);
        }
        MockTSwapPool tPool = new MockTSwapPool();
        s_pools[tokenAddress] = address(tPool); // pool[tokenAddress] -> gives the address of the new pool associated to tokenAddress
        s_tokens[address(tPool)] = tokenAddress;    // tokens[pool] -> simply gives the token address associated to the pool (I think it would have been better to use a struct for didactical purposes or better understanding)
        return address(tPool);
    }

    // function createPool2(address tokenAddress) external returns(address) {
    //     // Check pool has not been created
    //     // tPool has a function to getPriceOfOnePoolTokenInGet
    //     // Basically it creates the pool by storing in mappings
    //     // pool[tokenAddress] -> address of new pool
    //     // tokens[of pool create] -> gives address of associated tokenAddress 
    // }

    function getPool(address tokenAddress) external view returns (address) {
        return s_pools[tokenAddress];
    }
}
