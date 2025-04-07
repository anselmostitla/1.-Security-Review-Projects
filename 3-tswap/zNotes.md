https://youtu.be/pUWmJ86X_do?t=46971
## Checkout the commit hash

From the readme file copy the commit hash and run (I don't know why Patrick didn't do this step, he skipt this because he is going to update this commit hash to be the most recent push)

```shell
git checkout 2a47715b30cf11ca82db148704e67652ad679cd8
```

## Static analysis 

Authomatic checking code for issues without executing anything. Hence the debugging is `static`. Two common tools are `slither` and `aderyn`. 

### Slither

```shell
docker pull trailofbits/eth-security-toolbox
docker run -it -v /mnt/d/courses/solidity/patrick/security-review-projects/3-tswap:/share trailofbits/eth-security-toolbox
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

Patrick said that to update
```shell
pipx upgrade slither-analyzer
```

He also mentioned that pipx is a custom implementation of pip

### slither output

```shell
PuppyRaffle.withdrawFees() (src/PuppyRaffle.sol#192-201) sends eth to arbitrary user
        Dangerous calls:
        - (success,None) = feeAddress.call{value: feesToWithdraw}() (src/PuppyRaffle.sol#199)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations
```

To understand better what slither means with this vulnerability, we can go to the above Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations

If we want to ignore this part of output of solidity maybe because we have already checked the vulnerability and we have decided that it is in our control the vulnerability, go again to the above link, scroll up and click on `Wiki` section, then look on the right menu and click on `Usage`, then there you would see three bullets or markers, look at the `Options` marker or bullet, and then locate the subbullet or submarker `Triage mode`, there you can find ways to remove results

In our case we copy
```shell
//slither-disable-next-line DETECTOR_NAME
```

and to see what `DETECTOR_NAME` is, go again to the link Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations, there you will see something like this:

```shell
Configuration
  • Check: arbitrary-send-eth
  • Severity: High
  • Confidence: Medium
```

so in our case `DETECTOR_NAME` is given by the first bullet `Check`, that is `arbitrary-send-eth`

In our case we copy and paste in our solidity code
```solidty
//slither-disable-next-line arbitrary-send-eth
(bool success,) = feeAddress.call{value: feesToWithdraw}("");
```

and run again slither


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

## Solidity metrics

Don't forget to get solidity metrics

## Solidity visual developer

This is a vscode extension by tintinweb. If you go back to the solidity code, the variables will authomatically selected. Patrck Collins personally don't like it. But for the moment for me is ok.

## Tincho steps

1. Read the documentation
2. 

## .notes.md

Patrick Collins create the file .notes.md

# About

Patrick Collins makes emphasis on putting on your own words the project. I would like to try reading first the smart contract and try to put write on my own words about the project.

## Tool to inspect

Since this is a forge project we can run

```shell
forge inspect PuppyRaffle methods 
```

and it will print a list of methods

## chisel

I think only in foundry

```shell
chisel
type(uint64).max
```

## Authomatic report generating

In this part of the tutorial: https://www.youtube.com/watch?v=pUWmJ86X_do&t=28520s, Patrick Collins comments how he generates the reports, it is very interesting. Please review them.
