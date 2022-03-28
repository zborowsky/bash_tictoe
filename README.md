# BASH TICTOE

## Features:
1. Playing with computer
2. Playing with other player
3. Load saved game
4. Save game progress for playing later


### How to play
|     | 1   | 2   | 3   |
|-----|-----|-----|-----|
| 1   |     | X   |     |
| 2   |     |     |     |
| 3   | O   |     |     |

Players move should be always 2 digits, first number of row then of column.

Player 1 (X) - should input 12 

Player 2 (O) - should input 31 

### How to prepare own save
All save games should contain 9 signs
Only allowed signs are:
1. "X"
2. "O" 
3. "." - for empty board filed

For example if you want to save game progress which look as following:

| X   | X   | O   |
|-----|-----|-----|
| O   | .   | .   |
| .   | .   | O   |

Your save.txt file should contain

XXXO....O