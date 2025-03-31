// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Test} from "forge-std/Test.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {TSwapPool} from "../../src/TSwapPool.sol";
import {Handler} from "./Handler.t.sol";

contract Invariant is StdInvariant, Test {
   ERC20Mock poolToken;
   ERC20Mock weth;

   PoolFactory factory;
   TSwapPool pool; // poolToken-weth
   Handler handler;

   int256 constant STARTING_X = 100e18;  // starting poolToken
   int256 constant STARTING_Y = 50e18;   // starting weth



   function setUp() public {
      weth = new ERC20Mock();
      poolToken = new ERC20Mock();
      factory = new PoolFactory(address(weth));
      pool = TSwapPool(factory.createPool(address(poolToken)));

      // create those initials x & y balances
      poolToken.mint(address(this), uint256(STARTING_X));
      weth.mint(address(this), uint256(STARTING_Y));

      // I LEFT AT THIS TIME: https://youtu.be/pUWmJ86X_do?t=40383

      poolToken.approve(address(pool), type(uint256).max);
      weth.approve(address(pool), type(uint256).max);

      pool.deposit(uint256(STARTING_Y), uint256(STARTING_Y), uint256(STARTING_X), uint64(block.timestamp));

      handler = new Handler(pool);
      bytes4[] memory selectors = new bytes4[](2);
      selectors[0] = Handler.deposit.selector;
      selectors[1] = Handler.swapPoolTokenForWethBaseOnOutputWeth.selector;

      targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
      targetContract(address(handler));
   }

   function statefulFuzz_constantProductFormulaStaysTheSameX() public {
      // assert ????
      // The change in the pool size of WETH should follow this function
      // Dx = (B/(1-B))*x
      assertEq(handler.actualDeltaX(), handler.expectedDeltaX());
      // assertEq();
   }

   function statefulFuzz_constantProductFormulaStaysTheSameY() public {
      // assert ????
      // The change in the pool size of WETH should follow this function
      // Dx = (B/(1-B))*x
      assertEq(handler.actualDeltaY(), handler.expectedDeltaY());
      // assertEq();
   }
}


