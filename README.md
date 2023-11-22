# FOUR IN A ROW - A NEW VERSION
## Outcome
After finishing this assignment, we can proficiently use:
- MARS MIPS simulator.
- Arithmetic & data transfer instructions.
- Conditional branch and unconditional jump instructions.
- Procedures.

## Feature
1. In the first move of each player, they must drop the piece in the center column of the board.
2. In the middle of the game (after their first move), each player has 3 times to undo their move (before the opponent’s turn).
3. Each player also has one times to block the next opponent’s move. However, if the opponent has a chance to win (already had three pieces of the same colour vertically, horizontally or diagonally), player can not use this function.
4. And, instead of dropping a piece, each player has one times to remove one arbitrary piece of the opponent. It means that if a player chooses to drop a piece, player can not remove the opponent’s piece and vice versa. In case of removing a piece, if there are any pieces above this piece, they will fall down.
5. In addition, students have to handle the exception of placing a piece at an inappropriate column (out board or column that has full pieces) by restarting the move. And it also counts as a violation.
6. If any players try to violate all of the above conditions over 3 times. This player will lose the game.
7. In each turn, the program has to show: the number of remaining violation, undo, and the player’s name according to this turn.

## References

[1] Four in a Row, AI Gaming, https://help.aigaming.com/game-help/four-in-a-row.

[2] Connect Four, Wikipedia, https://en.wikipedia.org/wiki/Connect_Four.
