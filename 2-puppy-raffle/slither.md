INFO:Detectors:
PuppyRaffle.withdrawFees() (src/PuppyRaffle.sol#164-170) sends eth to arbitrary user
        Dangerous calls:
        - (success,None) = feeAddress.call{value: feesToWithdraw}() (src/PuppyRaffle.sol#168)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations
INFO:Detectors:
PuppyRaffle.selectWinner() (src/PuppyRaffle.sol#132-161) uses a weak PRNG: "winnerIndex = uint256(keccak256(bytes)(abi.encodePacked(msg.sender,block.timestamp,block.difficulty))) % players.length (src/PuppyRaffle.sol#135-136)" 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#weak-PRNG
INFO:Detectors:
PuppyRaffle.withdrawFees() (src/PuppyRaffle.sol#164-170) uses a dangerous strict equality:
        - require(bool,string)(address(this).balance == uint256(totalFees),PuppyRaffle: There are currently players active!) (src/PuppyRaffle.sol#165)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities
INFO:Detectors:
Reentrancy in PuppyRaffle.refund(uint256) (src/PuppyRaffle.sol#100-110):
        External calls:
        - address(msg.sender).sendValue(entranceFee) (src/PuppyRaffle.sol#106)
        State variables written after the call(s):
        - players[playerIndex] = address(0) (src/PuppyRaffle.sol#108)
        PuppyRaffle.players (src/PuppyRaffle.sol#23) can be used in cross function reentrancies:
        - PuppyRaffle.enterRaffle(address[]) (src/PuppyRaffle.sol#79-96)
        - PuppyRaffle.getActivePlayerIndex(address) (src/PuppyRaffle.sol#115-124)
        - PuppyRaffle.players (src/PuppyRaffle.sol#23)
        - PuppyRaffle.refund(uint256) (src/PuppyRaffle.sol#100-110)
        - PuppyRaffle.selectWinner() (src/PuppyRaffle.sol#132-161)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1
INFO:Detectors:
PuppyRaffle.constructor(uint256,address,uint256)._feeAddress (src/PuppyRaffle.sol#60) lacks a zero-check on :
                - feeAddress = _feeAddress (src/PuppyRaffle.sol#62)
PuppyRaffle.changeFeeAddress(address).newFeeAddress (src/PuppyRaffle.sol#174) lacks a zero-check on :
                - feeAddress = newFeeAddress (src/PuppyRaffle.sol#175)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation
INFO:Detectors:
Reentrancy in PuppyRaffle.refund(uint256) (src/PuppyRaffle.sol#100-110):
        External calls:
        - address(msg.sender).sendValue(entranceFee) (src/PuppyRaffle.sol#106)
        Event emitted after the call(s):
        - RaffleRefunded(playerAddress) (src/PuppyRaffle.sol#109)
Reentrancy in PuppyRaffle.selectWinner() (src/PuppyRaffle.sol#132-161):
        External calls:
        - (success,None) = winner.call{value: prizePool}() (src/PuppyRaffle.sol#158)
        - _safeMint(winner,tokenId) (src/PuppyRaffle.sol#160)
                - returndata = to.functionCall(abi.encodeWithSelector(IERC721Receiver(to).onERC721Received.selector,_msgSender(),from,tokenId,_data),ERC721: transfer to non ERC721Receiver implementer) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#441-447)
                - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#119)
        External calls sending eth:
        - (success,None) = winner.call{value: prizePool}() (src/PuppyRaffle.sol#158)
        - _safeMint(winner,tokenId) (src/PuppyRaffle.sol#160)
                - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#119)
        Event emitted after the call(s):
        - Transfer(address(0),to,tokenId) (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#343)
                - _safeMint(winner,tokenId) (src/PuppyRaffle.sol#160)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3
INFO:Detectors:
PuppyRaffle.selectWinner() (src/PuppyRaffle.sol#132-161) uses timestamp for comparisons
        Dangerous comparisons:
        - require(bool,string)(block.timestamp >= raffleStartTime + raffleDuration,PuppyRaffle: Raffle not over) (src/PuppyRaffle.sol#133)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp
INFO:Detectors:
4 different versions of Solidity are used:
        - Version constraint >=0.6.0 is used by:
                ->=0.6.0 (lib/base64/base64.sol#3)
        - Version constraint >=0.6.0<0.8.0 is used by:
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/access/Ownable.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/introspection/ERC165.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/introspection/IERC165.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/math/SafeMath.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/utils/Context.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/utils/EnumerableMap.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/utils/EnumerableSet.sol#3)
                ->=0.6.0<0.8.0 (lib/openzeppelin-contracts/contracts/utils/Strings.sol#3)
        - Version constraint >=0.6.2<0.8.0 is used by:
                ->=0.6.2<0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol#3)
                ->=0.6.2<0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol#3)
                ->=0.6.2<0.8.0 (lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol#3)
                ->=0.6.2<0.8.0 (lib/openzeppelin-contracts/contracts/utils/Address.sol#3)
        - Version constraint ^0.7.6 is used by:
                -^0.7.6 (src/PuppyRaffle.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used
INFO:Detectors:
PuppyRaffle._isActivePlayer() (src/PuppyRaffle.sol#180-187) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code
INFO:Detectors:
Version constraint ^0.7.6 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - FullInlinerNonExpressionSplitArgumentEvaluationOrder
        - MissingSideEffectsOnSelectorAccess
        - AbiReencodingHeadOverflowWithStaticArrayCleanup
        - DirtyBytesArrayToStorage
        - DataLocationChangeInInternalOverride
        - NestedCalldataArrayAbiReencodingSizeValidation
        - SignedImmutables
        - ABIDecodeTwoDimensionalArrayMemory
        - KeccakCaching.
It is used by:
        - ^0.7.6 (src/PuppyRaffle.sol#2)
solc-0.7.6 is an outdated solc version. Use a more recent version (at least 0.8.0), if possible.
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity
INFO:Detectors:
Low level call in PuppyRaffle.selectWinner() (src/PuppyRaffle.sol#132-161):
        - (success,None) = winner.call{value: prizePool}() (src/PuppyRaffle.sol#158)
Low level call in PuppyRaffle.withdrawFees() (src/PuppyRaffle.sol#164-170):
        - (success,None) = feeAddress.call{value: feesToWithdraw}() (src/PuppyRaffle.sol#168)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
INFO:Detectors:
Loop condition j < players.length (src/PuppyRaffle.sol#91) should use cached array length instead of referencing `length` member of the storage array.
 Loop condition i < players.length (src/PuppyRaffle.sol#116) should use cached array length instead of referencing `length` member of the storage array.
 Loop condition i < players.length (src/PuppyRaffle.sol#181) should use cached array length instead of referencing `length` member of the storage array.
 Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#cache-array-length
INFO:Detectors:
PuppyRaffle.commonImageUri (src/PuppyRaffle.sol#38) should be constant 
PuppyRaffle.legendaryImageUri (src/PuppyRaffle.sol#48) should be constant 
PuppyRaffle.rareImageUri (src/PuppyRaffle.sol#43) should be constant 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-constant
INFO:Detectors:
PuppyRaffle.raffleDuration (src/PuppyRaffle.sol#24) should be immutable 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-immutable
INFO:Slither:. analyzed (16 contracts with 92 detectors), 22 result(s) found