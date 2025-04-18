INFO:Detectors:
ThunderLoan.updateFlashLoanFee(uint256) (src/protocol/ThunderLoan.sol#265-270) should emit an event for: 
        - s_flashLoanFee = newFee (src/protocol/ThunderLoan.sol#269) 
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-events-arithmetic
INFO:Detectors:
Reentrancy in ThunderLoan.flashloan(address,IERC20,uint256,bytes) (src/protocol/ThunderLoan.sol#181-229):
        External calls:
        - assetToken.updateExchangeRate(fee) (src/protocol/ThunderLoan.sol#204)
        State variables written after the call(s):
        - s_currentlyFlashLoaning[token] = true (src/protocol/ThunderLoan.sol#208)
Reentrancy in ThunderLoan.flashloan(address,IERC20,uint256,bytes) (src/protocol/ThunderLoan.sol#181-229):
        External calls:
        - assetToken.updateExchangeRate(fee) (src/protocol/ThunderLoan.sol#204)
        - assetToken.transferUnderlyingTo(receiverAddress,amount) (src/protocol/ThunderLoan.sol#209)
        - receiverAddress.functionCall(abi.encodeCall(IFlashLoanReceiver.executeOperation,(address(token),amount,fee,msg.sender,params))) (src/protocol/ThunderLoan.sol#211-222)
        State variables written after the call(s):
        - s_currentlyFlashLoaning[token] = false (src/protocol/ThunderLoan.sol#228)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2
INFO:Detectors:
Reentrancy in ThunderLoan.flashloan(address,IERC20,uint256,bytes) (src/protocol/ThunderLoan.sol#181-229):
        External calls:
        - assetToken.updateExchangeRate(fee) (src/protocol/ThunderLoan.sol#204)
        Event emitted after the call(s):
        - FlashLoan(receiverAddress,token,amount,fee,params) (src/protocol/ThunderLoan.sol#206)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3