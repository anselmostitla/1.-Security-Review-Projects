### Compare protocols updates

This is a great tool to compare how a protocol has made some upgrades

```shell
upgradehub.xyz
```

### Checkout the commit hash

From the readme file copy the commit hash and run.

```shell
git checkout 8803f851f6b37e99eab2e94b4690c8b70e26b3f6
```

## Static analysis

Authomatic checking code for issues without executing anything. Hence the debugging is `static`. Two common tools are `slither` and `aderyn`.

### Solidity metrics

Run solidity metrics by hovering in directory `src`, then right click on `Solidity: Metrics`. This will divide your screen into two parts, the second one is the `Solidity: Metrics` report.

There is useful table within `Source Units in Scope`. Copy and paste that table in an excel sheet. There is a colum called `Complex. Score`, please order the rows from small to large, and begin reviewing from the less complex. For example the table for our case is:

<!-- To format the below table -->
<!-- ctrl + shift + p: Format Document  or  shift + alt + f -->

| File                                                   | Logic Contracts | Interfaces | Lines | nLines | nSLOC | Comment Lines | Complex. Score |
| ------------------------------------------------------ | --------------- | ---------- | ----- | ------ | ----- | ------------- | -------------- |
| 4-thunder/src/interfaces/ITSwapPool.sol                |                 | 1          | 6     | 5      | 3     | 1             | 3              |
| 4-thunder/src/interfaces/IThunderLoan.sol              |                 | 1          | 6     | 5      | 3     | 1             | 3              |
| 4-thunder/src/interfaces/IPoolFactory.sol              |                 | 1          | 6     | 5      | 3     | 1             | 3              |
| 4-thunder/src/interfaces/IFlashLoanReceiver.sol        |                 | 1          | 20    | 11     | 4     | 5             | 3              |
| 4-thunder/src/protocol/OracleUpgradeable.sol           | 1               |            | 32    | 32     | 23    | 2             | 18             |
| 4-thunder/src/protocol/AssetToken.sol                  | 1               |            | 105   | 105    | 65    | 24            | 41             |
| 4-thunder/src/upgradedProtocol/ThunderLoanUpgraded.sol | 1               |            | 288   | 258    | 143   | 90            | 127            |
| 4-thunder/src/protocol/ThunderLoan.sol                 | 1               |            | 295   | 265    | 147   | 97            | 129            |
| Totals                                                 | 4               | 4          | 758   | 686    | 391   | 221           | 327            |

### Slither

```shell
docker pull trailofbits/eth-security-toolbox
# docker run -it -v /mnt/d/courses/solidity/patrick/security-review-projects/3-tswap:/share trailofbits/eth-security-toolbox
docker run -it -v /mnt/d/courses/solidity/patrick/security-review-projects/4-thunder:/share trailofbits/eth-security-toolbox
```

It should appers something like

```shell
root@b40ba5553cde:/#
```

Then

```
cd /share
ls
slither .
slither . --exclude-dependencies
```

If you come to the slither repo: `https://github.com/crytic/slither`. Go to one of the best parts at `Wiki` at the top central. Then go to the right at `Usage` then at `Detector documentation`. There you can find all the different detectors.

### Aderyn

Here begins the tutorial with aderyn: https://youtu.be/pUWmJ86X_do?t=16893

The repo is here: https://github.com/Cyfrin/aderyn

To install it

```shell
cargo install aderyn
```

To run aderyn (Note there is a dot at the end in the second option if you are at current directory to be analyzed)

```shell
aderyn --root path/...
aderyn --root .
aderyn .
```

Here continues with aderyn: https://youtu.be/pUWmJ86X_do?t=27565

I will generate a

### Test Coverage

```
forge coverage
```

and for coverage based testing:

```
forge coverage --report debug
```

## About

Patrick Collins makes emphasis on putting on your own words the project. I would like to try reading first the smart contract and try to put write on my own words about the project.

### Vector attacks

- function getPriceInWeth(address token) can i break this?

### Ideas

### Questions

// q why are we using tswap? what does that have to do with flash loans

## Tool to inspect

Since this is a forge project we can run

```shell
forge inspect PuppyRaffle methods
```

and it will print a list of methods

## To inspect storage varaible

forge inspect ThunderLoan storage
