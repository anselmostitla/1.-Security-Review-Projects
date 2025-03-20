Denial of service attack

### [S-#] Looping through players array to check for duplicates in `PuppyRaffle::enterRaffle` is a potential denial of service (DoS) attack, incrementing gas cost for future entrants.

```shell

Please comment this shell block, this won't be part of the report, it is just to help us figure out the severity [S-#]

### [S-#]

IMPACT: MEDIUM
LIKELIHOOD: MEDIUM (since it will cost a lot to an attacker to do this)

So for us [S-#] = [M-#], we will figure the number # later
```


**Description** The `PuppyRaffle::enterRaffle` function loops through the `players` array to check for duplicates. However the longer the `PuppyRaffle::players` array is, the more checks a new player will have to make. This means the gas cost for players who enter right when the raffle starts will be dramatically lower than those who enter later. Every additional address in the `PuppyRaffle::players` array, is an additional check the loop will have to make.  

```javascript
        // Check for duplicates
        // @audit DoS attack  
@>      for (uint256 i = 0; i < players.length - 1; i++) {
            for (uint256 j = i + 1; j < players.length; j++) {
                require(players[i] != players[j], "PuppyRaffle: Duplicate player");
            }
        }
```

**Impact** The gas cost for raffle entrants will greatly increase as more players enter the raffle. Discouraging later users from entering, and causing a rush at the start of the raffle to be one of the first entrants in the queue.

An attacker might fill the raffle `PuppyRaffle::players` array so big, that no one else enters, guaranteeing themselves the win 

**Proof of concept**

If we have two sets of 100 players enter, the gas cost will be as such:
- 1st 100 players: ~6503275 gas 
- 2nd 1500 players: ~1057057316 gas 

This is more than 3x more expensive for the second 100 players.

/* In the private audit maybe don't put the code directly into the findings report but in a competive audit you definitively put this in */

<details>
<summary>PoC</summary>

Place the following test into `PuppyRaffleTest.t.sol`

```javascript
    function testDoS() public {
        vm.txGasPrice(1);
        address[] memory players = new address[](100);

        for (uint i=0; i<100; i++){
            players[i] = address(i);
        }
        
        uint gasStart = gasleft();
        puppyRaffle.enterRaffle{value: entranceFee*players.length}(players);

        uint gasEnd = gasleft();
        uint gasUsedFirst = (gasStart - gasEnd) * tx.gasprice;
        console.log("Gas cost of first 100 players: ", gasUsedFirst);

        uint nextNumPlayers = 1490;
        address[] memory players2 = new address[](nextNumPlayers);
        for (uint i = 100; i<nextNumPlayers + 100; i++){
            players2[i-100] = address(i);
        }
        puppyRaffle.enterRaffle{value: entranceFee*players2.length}(players2);

        uint gasEnd2 = gasleft();
        // vm.expectRevert("")
        uint gasUsedSecond = (gasStart - gasEnd2) * tx.gasprice;
        console.log("Gas cost of rest of players: ", gasUsedSecond);

        assert(gasUsedFirst < gasUsedSecond);
    }

```



</details>

**Recommended Mitigation** There are a few recommendations.

1. Consider allowing duplicates. Users can make new wallet addresses anyway, so a duplicate check doesn't prevent same person from entering multiple times, only the same wallet address. 
2. Consider a mapping to check for dupplicates. This would allow constant time lookup whether a user has already entered. You could have each raffle have a `uint256` id and the mapping would be a `raffleId` and a `player address` mapped to `true` or `false`.

```diff

+   uint256 public raffleId;   // This will be incremented for next raffle in selectWinner()
+   mapping(uint256 => mapping(address => bool)) public isParticipant;
   
      .
      .
      .

    function enterRaffle(address[] memory newPlayers) public payable {
        require(msg.value == entranceFee * newPlayers.length, "PuppyRaffle: Must send enough to enter raffle");
        for (uint256 i = 0; i < newPlayers.length; i++) {
            players.push(newPlayers[i]);
+            require(!isParticipant[raffleId][newPlayers[i]], "PuppyRaffle: Duplicate player");      /*+++ new line +++*/
+            isParticipant[raffleId][newPlayers[i]] = true;                                          /*+++ new line +++*/
        }

        // Check for duplicates
-        for (uint256 i = 0; i < players.length - 1; i++) {                              /*+++ drop this line +++*/
-            for (uint256 j = i + 1; j < players.length; j++) {                          /*+++ drop this line +++*/
-                require(players[i] != players[j], "PuppyRaffle: Duplicate player");     /*+++ drop this line +++*/
-            }                                                                           /*+++ drop this line +++*/
-        }                                                                               /*+++ drop this line +++*/
        emit RaffleEnter(newPlayers);
    }

    function selectWinner() external {
      
      .
      .
      .

      delete players;
+     raffleId += 1; // incrementing for the next raffle
      raffleStartTime = block.timestamp;
      
      .
      .
      .

    }
```

Alternatively, you could use [OpenZeppelin's `EnumerableSet` library](https://docs.openzeppelin.com/contracts/4.x/api/utils#EnumerableSet).