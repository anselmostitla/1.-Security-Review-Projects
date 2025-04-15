
### [H-1] Erroneous `ThunderLoan::updateExchangeRate` in the deposit function causes protocol to think it has more fees than it really does, which blocks redemptions incorrectly sets the exchange rate

**Description:** In the ThunderLoan system the `ThunderLoan::exchainRate` is responsible for calculating the exchange rate between assetTokens and underlying tokens. In a way, is responsible for keeping track of how many fees to give to liquidity providers.

However the `ThunderLoan::deposit` function, updates this rate without collecting any fees! 

```javascript
    function deposit(IERC20 token, uint256 amount) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) / exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);
@>      uint256 calculatedFee = getCalculatedFee(token, amount);
@>      assetToken.updateExchangeRate(calculatedFee);
        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }
```

**Impact:** There are several impacts to this bug.

1. The `redeem` function is blocked because protocol thinks the owed tokens is more than it has
2. Rewards is incorrectly calculated, leading to liquidity providers getting way more or less than deserved 

**Proof of Concept:**

1. LP deposits
2. User takes out a flash loan 
3. It is now imposible for LP to redeem

<details>
<summary>Proof of code</summary>

Place the following into `ThunderLoanTest.t.sol` 
```javascript
    function testRedeemAfterLoan() public setAllowedToken hasDeposits {
        uint256 amountToBorrow = AMOUNT * 10;
        uint256 calculatedFee = thunderLoan.getCalculatedFee(tokenA, amountToBorrow);
        vm.startPrank(user);
        tokenA.mint(address(mockFlashLoanReceiver), calculatedFee);
        thunderLoan.flashloan(address(mockFlashLoanReceiver), tokenA, amountToBorrow, "");
        vm.stopPrank();

        uint256 amountToRedeem = type(uint256).max;
        vm.startPrank(liquidityProvider);
        thunderLoan.redeem(tokenA, amountToRedeem);
    }
```
</details>

**Recommended Mitigation** Remove the incorrectly updated exchange rate lines from `ThunderLoan::deposit`

```diff
    function deposit(IERC20 token, uint256 amount) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) / exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);
-       uint256 calculatedFee = getCalculatedFee(token, amount);
-       assetToken.updateExchangeRate(calculatedFee);
        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }
```

### [H-2] Mixing up variable location causes storage collisions in `ThunderLoan::s_flashLoanFee` and `ThunderLoan::s_currentlyFlashLoaning`, freezing protocol

**Description:** `ThunderLoan.sol`has two variables in the following order 

````javascript
    uint256 private s_feePrecision; 
    uint256 private s_flashLoanFee; 
```

However the upgraded contract `ThunderLoanUpgraded.sol` has them in different order:

```javascript
    uint256 private s_flashLoanFee; // 0.3% ETH fee
    uint256 public constant FEE_PRECISION = 1e18;
```

Due to how solidity storage works, after the upgrade the `s_flashLoanFee` will have the value of `s_feePrecision`. You cannot adjust the position of storage variables, and removing storage variables for constant variables, breaks the storage locations as well. 

**Impact:** After the upgrade, the `s_flashLoanFee` will have the value of `s_feePrecision`. This means that users who take flash loans right after an upgrade will be charge the wrong fee.

More importantly the `s_currentlyFlashLoaning` mapping will start in the wrong storage slot

**Proof of Concept:**

<details>
<summary>Proof of code</summary>

Place the following into `ThunderLoanTest.t.sol`

```javascript
import { ThunderLoanUpgraded } from "../../src/upgradedProtocol/ThunderLoanUpgraded.sol";
.
.
.
function testUpgradeBreaks() public {
    uint256 feeBeforeUpgrade = thunderLoan.getFee();
    vm.startPrank(thunderLoan.owner());
    ThunderLoanUpgraded upgraded = new ThunderLoanUpgraded();
    thunderLoan.upgradeToAndCall(address(upgraded), "");
    uint256 feeAfterUpgrade = thunderLoan.getFee();
    vm.stopPrank();

    console.log("feeBeforeUpgrade: ", feeBeforeUpgrade);
    console.log("feeAfterUpgrade: ", feeAfterUpgrade);
    assert(feeBeforeUpgrade != feeAfterUpgrade);
}
```

You can also see the storage layout difference by running `forge inspect ThunderLoan.sol storage` and `forge inspect ThunderLoanUpgraded.sol storage`

</details>

**Recommended Mitigation** If you must remove the storage variable, leave it as blank as not to mess up the storage slots.

```diff
-    uint256 private s_feePrecision; 
-    uint256 private s_flashLoanFee; // 0.3% ETH fee

+    uint256 private s_blank; // 0.3% ETH fee
+    uint256 private s_flashLoanFee; // 0.3% ETH fee
+    uint256 public constant FEE_PRECISION = 1e18;
```



### [M-1] Using TSwap as a price oracle leads to price and oracle manipulation attacks

**Description:** The TSwap protocol is a constant product formula base AMM (automated marked maker). The price of the token is determined by how many reserves are on either side of the pool. Because of this, it is easy for malicius users to manipulate the price of a token by buying or selling a large amount of the token in the same transaction, essentially ignoring protocol fees. 

**Impact:** Liquidity providers will drastically reduce fees for providing liquidity

**Proof of Concept:** 

The following all happens in one transaction.

1. User takes a flashloan from `ThunderLoan` for 1000 `tokenA`. They are charged the original fee `feeOne`. During the flash loan they do the following:
   1. User sells 1000 `tokenA` tanking the price.
   2. Instead of repaying right away, the user takes out another flash loan for another 1000 `tokenA` 
      1. Do to the fact that the way `ThunderLoan` calculates price based on the `TSwapPool`, this second flash is substantially cheaper.
   ```javascript
       function getPriceInWeth(address token) public view returns (uint256) {
        address swapPoolOfToken = IPoolFactory(s_poolFactory).getPool(token);
        return ITSwapPool(swapPoolOfToken).getPriceOfOnePoolTokenInWeth();
    }
   ```
   3. The user then repays the first flash loan, and then repays the second flash loan.
   
I have created a proof of code located in my `audit-data` folder. It is too large to include here.

**Recommended Mitigation** Consider using a different price oracle mechanism, like a chainlink price feed with a Uniswap TWAP fallback oracle.