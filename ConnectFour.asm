.data
playerOneName: .space 256	# Name of player 1
playerTwoName: .space 256	# Name of player 2

#1st turn
firstOne: .word 1
firstTwo: .word 1

afterOne: .word 1
afterTwo: .word 1


# Remove
removePlayerOne: .word 1
removePlayerTwo: .word 1

# Block
blockPlayerOne: .word 1
blockPlayerTwo: .word 1
winChance_PlayerOne: .word 0
winChance_PlayerTwo: .word 0
index_WinChance_1: .word 1, 1, 1, 1
index_WinChance_2: .word 1, 1, 1, 1
tempIndex: .word 0, 0, 0, 0
jumpWinCheckFromRemove: .word 0


boardGame: .space 168		# display playboard
first: .asciiz "======================================================================\n==================    [Welcome to Connect Four]     ==================\n======================================================================\n"	#out string
nameInput1: .asciiz "\nPlayer One's name: "		#out string
nameInput2: .asciiz "Player Two's name: "		#out string
rules: .asciiz "\nThis is a turn-based 2-player game.\nThe rule is:\n+ Each player put their designated piece into a 6 x 7 Board.\n+ The game ends when either one of the player makes 4 consecutive.\n+ Additional function for players: remove, undo and block.\n"
endl: .asciiz "\n"
X_piece: .asciiz " X "
O_piece: .asciiz  " O "
emptyPiece: .asciiz " . "
newline: .asciiz "\n"
# typeOfPiece: .word 0 #0 for O, 1 for X
typePlayerOne: .word 0
typePlayerTwo: .word 1
# playerOne: .asciiz "Player 1: "
# playerTwo: .asciiz "Player 2: "

noUndo1: .asciiz "\nNOTE: Player 1 has no undo left.\n"
noUndo2: .asciiz "\nNOTE: Player 2 has no undo left.\n"
noBlock1: .asciiz "\nNOTE: Player 1 has no block left.\n"
noBlock2: .asciiz "\nNOTE: Player 2 has no block left.\n"
violationMax1: .asciiz "WARNING: Player 1 has made 3 faults.\n"
violationMax2: .asciiz "WARNING: Player 2 has made 3 faults.\n"

invalidDataText: .asciiz "\n\nWARNING: You chose INVALID column. Let's restart your turn.\n"
ColumnFullCommand: .asciiz "\n WARNING: The column you have chosen is full. Let's select a different column.\n"

#  After Random
random1: .asciiz "\nNOTE: Player 1 use 'X', and player 2 go with 'O'.\n"
random2: .asciiz "\nNOTE: Player 1 use 'O', and player 2 go with 'X'.\n"

# 1st move
firstMove: .asciiz "\nREQUIREMENT: In the first move, players MUST place pieces in the middle column.\n"
removeTrue: .word 0

# Print each turn
gameAnnounce: .asciiz "\n=========================== [In Progress] ============================\n"
gameAnnounce_below: .asciiz "############################################"
playerTurnOne: .asciiz "Player 1: "
playerTurnTwo: .asciiz "Player 2: "
hyphen: .asciiz "Piece:"
faultCount: .asciiz "           |           Fault: "
undoCount: .asciiz "           |           Undo: "

invalidInput: .asciiz "\n\nWARNING: Invalid input. Please enter again.\n\n"
removeRequest: .asciiz "You have only ONE chance to remove. Do you want to REMOVE one piece of your opponent? (0 = NO  |  1 = YES): "
noRemoveLeft_1: .asciiz "\nNOTE: Player 1 has no remove left.\n"
noRemoveLeft_2: .asciiz "\nNOTE: Player 2 has no remove left.\n"
removeColumn: .asciiz "\n- Please choose the COLUMN of piece you want to remove: "
removeRow: .asciiz "\n- Please choose the ROW of piece you want to remove: "
removeFalse: .asciiz "\n\nThe place you choose do not have piece of opponent.\n"

#In-Game
boardText: .asciiz "\n                           -- BOARD GAME --\n\n"
columnNumber: .asciiz "                         | 1  2  3  4  5  6  7 \n                       ------------------------\n"
requestDrop: .asciiz "\nPlease choose a column from 1 to 7 to DROP your piece: "

#Print after dropping pieces
undoRequest: .asciiz "\nDo you want to UNDO your move? (0 = NO  |  1 = YES): "
blockRequest: .asciiz "\nYou have only ONE chance to block. Do you want to BLOCK your opponent's next step? (0 = NO  |  1 = YES): "
blockIgnore: .asciiz "\nYour opponent has a chance to win now. You can not use BLOCK function.\n"
# End Game
tieGame: .asciiz "\nThis is a Tie game. Let's start a new game to find the winner.\n"
winner: .asciiz "\n\n=========================== CONGRATULATION! ===========================\n\n"
winner1: .asciiz "Player 1 is the winner.\n"
winner2: .asciiz "Player 2 is the winner.\n"
playerWinner: .asciiz "- Player's name: "
printPiece: .asciiz "- Type of piece:"
numPieces: .asciiz "\n- Number of pieces: "
endGame: .asciiz "\n\n=============================== THE END ===============================\n"
one: .asciiz    "                       1 |"
two: .asciiz    "                       2 |"
three: .asciiz  "                       3 |"
four: .asciiz   "                       4 |"
five: .asciiz   "                       5 |"
six: .asciiz    "                       6 |"
cover: .asciiz  "                       |"
endcover: .asciiz " --------------------------"
.text
main:
    li $s3, 0
    li $s4, 0
    li $t5, 0
    li $t6, 0
    li $t0, 0
    li $t3, 0
    
    loop:
        sw $t0, boardGame($t3)     
        addi $t3, $t3, 4   
        bne $t3, 168, loop  

    li $v0, 4
	la $a0, first
	syscall
    la $a0, rules
    li $v0, 4
    syscall
	
    # Input playerOne name
	li $v0, 4
	la $a0, nameInput1		# ask for name
	syscall
	li $v0, 8
	li $a1, 100
	la $a0, playerOneName	# read the name
	syscall
	la	$a0, playerOneName
	#jal	removeNewline

    # Input playerTwo name
	li $v0, 4
	la $a0, nameInput2		# ask for name
	syscall
	li $v0, 8
	li $a1, 100
	la $a0, playerTwoName	# read the name
	syscall
	la	$a0, playerTwoName
    
    randomPieces:
        # Generate a random number between 0 and 1
        li $a1, 2 # max bound
        li $v0, 42        
        syscall           
        beq $a0, 0, LoadPlayer1_X

        LoadPlayer2_X:  # 1 = O, 2 = X
            la $s0, O_piece
            move $k0, $s0
            la $s0, X_piece
            move $k1, $s0
            la $a0, random2
            li $v0, 4
            syscall

            # Setup boardGame for the 1st turn  
            # li $t0, 1
            # li $t1, 12
            # li $t2, 40
            # sw $t0, boardGame($t1)
            # li $t0, 2
            # sw $t0, boardGame($t2)
            
            la $a0, firstMove
            li $v0, 4
            syscall
            jal boardGamePrint_Temp
            addi $s7, $zero, 2
            j playerOneTurn

        LoadPlayer1_X: # 1 = X; 2 = O
            la $s0, X_piece
            move $k0, $s0
            la $s0, O_piece
            move $k1, $s0
            la $a0, random1
            li $v0, 4
            syscall
            # Reset type of Piece
            la $t0, typePlayerOne
            li $t1, 1
            sw $t1, ($t0)
            la $t0, typePlayerTwo
            li $t1, 0
            sw $t1, ($t0)

            # Setup boardGame for the 1st turn
            # li $t0, 1
            # li $t1, 12
            # li $t2, 40
            # sw $t0, boardGame($t1)
            # li $t0, 2
            # sw $t0, boardGame($t2)     

            la $a0, firstMove
            li $v0, 4
            syscall
            jal boardGamePrint_Temp

            addi $s7, $zero, 2
            j playerOneTurn

################# ! BEFORE DROPPING #################
preDrop:
    la $a0, gameAnnounce
    li $v0, 4
    syscall

    beq $s7, 1, getName_playerTwo
    beq $s7, 2, getName_playerOne
    
    getName_playerOne:
        la $a0, playerTurnOne
        li $v0, 4
        syscall
        la $a0, playerOneName
        li $v0, 4
        syscall
        la $a0, hyphen
        li $v0, 4
        syscall
        lw $t7, typePlayerOne
        beq $t7, 1, printX
        printO:
            la $a0, O_piece
            li $v0, 4
            syscall
            j moreInfo_1
        printX: 
            la $a0, X_piece
            li $v0, 4
            syscall
            j moreInfo_1
        
        moreInfo_1:
        la $a0, faultCount
        li $v0, 4
        syscall
        move $a0, $t5
        li $v0, 1
        syscall
        la $a0, undoCount
        li $v0, 4
        syscall
        move $a0, $s3
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        
        lw $t8, firstOne
        beq $t8, 1, dropInto
        lw $t8, removePlayerOne
        bnez $t8, removeCommand_One
        j noRemove_One

        removeCommand_One: 
            la $a0, removeRequest
            li $v0, 4
            syscall
            li $v0, 12
            syscall
            beq $v0, '1', removeProgress
            beq $v0, '0', dropInto
            
            #invalid
            la $a0, invalidInput
            li $v0, 4
            syscall
            j removeCommand_One

        noRemove_One:
            la $a0, noRemoveLeft_1
            li $v0, 4
            syscall
            j dropInto

    getName_playerTwo:
        la $a0, playerTurnTwo
        li $v0, 4
        syscall
        la $a0, playerTwoName
        li $v0, 4
        syscall
        la $a0, hyphen
        li $v0, 4
        syscall
        lw $t7, typePlayerTwo
        beq $t7, 1, printX_2
        printO_2:
            la $a0, O_piece
            li $v0, 4
            syscall
            j moreInfo_2

        printX_2:
            la $a0, X_piece
            li $v0, 4
            syscall
            j moreInfo_2
        
        moreInfo_2:
        la $a0, faultCount
        li $v0, 4
        syscall
        move $a0, $t6
        li $v0, 1
        syscall
        la $a0, undoCount
        li $v0, 4
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        
        lw $t8, firstTwo
        beq $t8, 1, dropInto
        lw $t8, removePlayerTwo
        bnez $t8, removeCommand_Two
        j noRemove_Two

        removeCommand_Two: 
            la $a0, removeRequest
            li $v0, 4
            syscall
            li $v0, 12
            syscall
            beq $v0, '1', removeProgress
            beq $v0, '0', dropInto
            
            #invalid
            la $a0, invalidInput
            li $v0, 4
            syscall
            j removeCommand_Two

        noRemove_Two:
            la $a0, noRemoveLeft_2
            li $v0, 4
            syscall
            j dropInto
    
    dropInto:
        la $a0, requestDrop
        li $v0, 4
        syscall
        la $v0, 12
        syscall

    beq $s7, 1, storeTwo
    beq $s7, 2, storeOne
################# END #################


################# !AFTER DROPPING #################
postDrop:   
    #Undo
    beq $s7, 1, checkUndoOne
    beq $s7, 2, checkUndoTwo
    checkUndoOne:
        lw $t8, afterOne
        beq $t8, 1, afterCheck
        beq $s3, 0, afterUndo_1
        j undoAsk
    checkUndoTwo:
        lw $t8, afterTwo
        beq $t8, 1, afterCheck
        beq $s4, 0, afterUndo_2
        j undoAsk

    undoAsk:
        la $a0, undoRequest
        la $v0, 4
        syscall
        la $v0, 12
        syscall
        beq $v0, '1', undoProgess
        beq $v0, '0', afterUndo

        #invalid
        la $a0, invalidInput
        li $v0, 4
        syscall
        j undoAsk

        
    afterUndo_1:
        la $a0, noUndo1
        li $v0, 4
        syscall
        j winCheck
    afterUndo_2:
        la $a0, noUndo2
        li $v0, 4
        syscall
        j winCheck

    afterUndo:
        j winCheck

    afterCheck:
        #Block
        beq $s7, 1, playerOneAsk_Block
        beq $s7, 2, playerTwoAsk_Block
        playerOneAsk_Block:
            lw $t7, afterOne
            beq $t7, 0, midBlockOne
            li $s3, 3
            la $t7, afterOne
            sw $zero, ($t7)

            midBlockOne:
            lw $t7, winChance_PlayerTwo
            beq $t7, 1, blockIgnore_One
            
            lw $t7, blockPlayerOne
            beq $t7, 1, blockBegin
            la $a0, noBlock1
            li $v0, 4
            syscall
            j playerTwoTurn

            blockIgnore_One:
                la $a0, blockIgnore
                li $v0, 4
                syscall
                j playerTwoTurn

        playerTwoAsk_Block:
            lw $t7, afterTwo
            beq $t7, 0, midBlockTwo
            li $s4, 3
            la $t7, afterTwo
            sw $zero, ($t7)

            midBlockTwo:
            lw $t7, winChance_PlayerOne
            beq $t7, 1, blockIgnore_Two

            lw $t7, blockPlayerTwo
            beq $t7, 1, blockBegin
            la $a0, noBlock2
            li $v0, 4
            syscall
            j playerOneTurn

            blockIgnore_Two:
                la $a0, blockIgnore
                li $v0, 4
                syscall
                j playerOneTurn

        blockBegin:
            la $a0, blockRequest
            la $v0, 4
            syscall
            la $v0, 12
            syscall
            beq $v0, '1', blockProgress 
            beq $v0, '0', newTurn

            #invalid
            la $a0, invalidInput
            li $v0, 4
            syscall
            j blockBegin

        newTurn:
            beq $s7, 1, playerTwoTurn
            beq $s7, 2, playerOneTurn
################# END #################


################# *PRINT BOARD #################
boardGamePrint:
    la $a0, endl
    li $v0, 4
    syscall
    la $a0, boardText
    li $v0, 4
    syscall
    la $a0, columnNumber
    li $v0, 4
    syscall

    ########## LINE 1 ##########
    li $s1, 168
    li $s0, 140
    la $a0, one
    li $v0, 4
    syscall
    Row1:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_1
        beq $s2, 1, printPlayerOne_1
        beq $s2, 2, printPlayerTwo_1
    
    printEmpty_1:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R1
    
    printPlayerOne_1:
        move $a0, $k0
        li $v0, 4
        syscall
        j R1
    
    printPlayerTwo_1:
        move $a0, $k1
        li $v0, 4
        syscall
        j R1
    
    R1:
        addi $s0, $s0, 4
        bne $s0, $s1, Row1

        la $a0, newline	
        li $v0, 4
        syscall
    
    ########## LINE 2 ##########
    li $s1, 140
    li $s0, 112
    la $a0, two
    li $v0, 4
    syscall
    Row2:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_2
        beq $s2, 1, printPlayerOne_2
        beq $s2, 2, printPlayerTwo_2
    
    printEmpty_2:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R2
    
    printPlayerOne_2:
        move $a0, $k0
        li $v0, 4
        syscall
        j R2
    
    printPlayerTwo_2:
        move $a0, $k1
        li $v0, 4
        syscall
        j R2
    
    R2:
        addi $s0, $s0, 4
        bne $s0, $s1, Row2

        la $a0, newline	
        li $v0, 4
        syscall

    ########## LINE 3 ##########
    li $s1, 112
    li $s0, 84
    la $a0, three
    li $v0, 4
    syscall
    Row3:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_3
        beq $s2, 1, printPlayerOne_3
        beq $s2, 2, printPlayerTwo_3
    
    printEmpty_3:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R3
    
    printPlayerOne_3:
        move $a0, $k0
        li $v0, 4
        syscall
        j R3
    
    printPlayerTwo_3:
        move $a0, $k1
        li $v0, 4
        syscall
        j R3
    
    R3:
        addi $s0, $s0, 4
        bne $s0, $s1, Row3

        la $a0, newline	
        li $v0, 4
        syscall

    ########## LINE 4 ##########
    li $s1, 84
    li $s0, 56
    la $a0, four
    li $v0, 4
    syscall
    Row4:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_4
        beq $s2, 1, printPlayerOne_4
        beq $s2, 2, printPlayerTwo_4
    
    printEmpty_4:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R4
    
    printPlayerOne_4:
        move $a0, $k0
        li $v0, 4
        syscall
        j R4
    
    printPlayerTwo_4:
        move $a0, $k1
        li $v0, 4
        syscall
        j R4
    
    R4:
        addi $s0, $s0, 4
        bne $s0, $s1, Row4

        la $a0, newline	
        li $v0, 4
        syscall
    
    ########## LINE 5 ##########
    li $s1, 56
    li $s0, 28
    la $a0, five
    li $v0, 4
    syscall
    Row5:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_5
        beq $s2, 1, printPlayerOne_5
        beq $s2, 2, printPlayerTwo_5
    
    printEmpty_5:
        la $a0,emptyPiece
        li $v0, 4
        syscall
        j R5
    
    printPlayerOne_5:
        move $a0, $k0
        li $v0, 4
        syscall
        j R5
    
    printPlayerTwo_5:
        move $a0, $k1
        li $v0, 4
        syscall
        j R5
    
    R5:
        addi $s0, $s0, 4
        bne $s0, $s1, Row5

        la $a0, newline	
        li $v0, 4
        syscall

    ########## LINE 6 ##########
    li $s1, 28
    li $s0, 0
    la $a0, six
    li $v0, 4
    syscall
    Row6:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_6
        beq $s2, 1, printPlayerOne_6
        beq $s2, 2, printPlayerTwo_6
    
    printEmpty_6:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R6
    
    printPlayerOne_6:
        move $a0, $k0
        li $v0, 4
        syscall
        j R6
    
    printPlayerTwo_6:
        move $a0, $k1
        li $v0, 4
        syscall
        j R6
    
    R6:
        addi $s0, $s0, 4
        bne $s0, $s1, Row6

        la $a0, newline	
        li $v0, 4
        syscall

    beq $s7, 1, postOne
    beq $s7, 2, postTwo
################# END #################


################# TODO: PLAYER ONE's TURN #################
playerOneTurn:
    li $s7, 2
    jal preDrop

    # Store Data of PlayerOne
    storeOne:
    li $a0, 1  
    jal StoreData

    # Print 
    printOne:
    j boardGamePrint

    # Ask after Print
    postOne:
    j postDrop
################# END #################


################# TODO: PLAYER TWO's TURN #################
playerTwoTurn:
    li $s7, 1
    j preDrop

    # Store Data of PlayerTwo
    storeTwo:
    li $a0, 2
    j StoreData

    # Print 
    printTwo:
    j boardGamePrint

    # Ask after Print
    postTwo:
    j postDrop
################# END #################


#################* UNDO #################
undoProgess:
    beq $s7, 1, playerOneUndo
    beq $s7, 2, playerTwoUndo

    playerOneUndo:
        beqz $s3, NoUndo_PlayerOne
        
        undoPlayerOne:
            addi $s3, $s3, -1
            li $t8, 0
            sw $t8, boardGame($s6)
            jal boardGamePrint_Temp
            li $s7, 2
            j rePrint

        NoUndo_PlayerOne:
            la $a0, noUndo1
            li $v0, 4
            syscall
            j playerTwoTurn


    playerTwoUndo:
        beqz $s4, NoUndo_PlayerTwo
        
        undoPlayerTwo:
            addi $s4, $s4, -1
            li $t8, 0
            sw $t8, boardGame($s6)
            jal boardGamePrint_Temp
            li $s7, 1
            j rePrint

        NoUndo_PlayerTwo:
            la $a0, noUndo2
            li $v0, 4
            syscall
            j playerOneTurn
################# END #################


################# TODO: BLOCK #################
blockProgress:
    beq $s7, 1, playerOneBlock
    beq $s7, 2, playerTwoBlock

    playerOneBlock:
        la $t7, blockPlayerOne
        sw $zero, ($t7)
        li $s7, 2
        j playerOneTurn
    
    playerTwoBlock:
        la $t7, blockPlayerTwo
        sw $zero, ($t7)
        li $s7, 1
        j playerTwoTurn
################# END #################


################# * REMOVE #################
removeProgress:
    la $a0, removeRow
    li $v0, 4
    syscall
    la $v0, 12
    syscall
    subi $v0, $v0, 48
    move $a2, $v0

    la $a0, removeColumn
    li $v0, 4
    syscall
    la $v0, 12
    syscall
    subi $v0, $v0, 48
    move $a3, $v0

    # Get the index of elements
    subi $a2, $a2, 1
    subi $a3, $a3, 1
    move $s1, $a2
    beq $s1, 0, nextRemove
    loopRow:
        addi $a2, $a2, 27
        subi $s1, $s1, 1
        beq $s1, 0, nextRemove
        j loopRow

    nextRemove:
    li $s1, 6
    sub $a3, $s1, $a3
    move $s1, $a3
    add $a3, $a3, $s1
    add $a3, $a3, $s1
    add $a3, $a3, $s1

    addi $t7, $zero, 164
    sub $t7, $t7, $a2
    sub $t7, $t7, $a3
    move $s1, $t7

    beq $s7, 2, playerOneRemove
    beq $s7, 1, playerTwoRemove

    playerOneRemove:
    
        lw $s2, boardGame($t7)
        beq $s2, 2, removeTrue_One
        removeFalse_One:
            la $a0, removeFalse
            li $v0, 4
            syscall
            j removeProgress

        removeTrue_One:
            sw $zero, boardGame($t7)
            li $t7, 0
            la $a3, removePlayerOne
            sw $t7, ($a3)

            # #check if index = winChance
            # li $s0, 0
            # lw $t7, index_WinChance_2($s0)
            # beq $s1, $t7, resetIndex_1

            # addi $s0, $s0, 4
            # lw $t7, index_WinChance_2($s0)
            # beq $s1, $t7, resetIndex_1

            # addi $s0, $s0, 4
            # lw $t7, index_WinChance_2($s0)
            # beq $s1, $t7, resetIndex_1
            # j noReset_1

            # resetIndex_1:    
            #     la $s0, index_WinChance_2
            #     li $t7, 1
            #     sw $t7, 0($s0)
            #     sw $t7, 4($s0)
            #     sw $t7, 8($s0)
            #     sw $t7, 12($s0)
            #     la $s0, jumpWinCheckFromRemove
            #     sw $t7, ($s0)
            #     la $s0, winChance_PlayerTwo
            #     li $t7, 0
            #     sw $t7, ($s0)

            # noReset_1:
                li $t7, 1
                la $s0, jumpWinCheckFromRemove
                sw $t7, ($s0)

            move $t7, $s1
            innerFalling_One:
                addi $a3, $t7, 28
                bgt $a3, 168, outFalling_One
                lw $a2, boardGame($a3)
                sw $a2, boardGame($t7)
                addi $t7, $t7, 28
                j innerFalling_One

            outFalling_One:
                subi $a3, $a3, 28
                sw $zero, boardGame($a3)
                subi $a3, $a3, 168
                # each falling-index winCheck
                lw $s0, jumpWinCheckFromRemove
                beq $s0, 1, eachCheckOne
                finishRemoveCheck_1:
                    sw $zero, jumpWinCheckFromRemove
                    jal winChanceUpdate
                    jal boardGamePrint_Temp
                    li $s7, 1
                    j playerOneAsk_Block

                eachCheckOne:
                    addi $a3, $a3, 28

                    # give true value to $a0, save temp $s7 to $s0
                    move $s0, $s7
                    lw $t7, boardGame($a3)
                    bgt $a3, 164, finishRemoveCheck_1
                    beq $t7, 0, eachCheckOne
                    
                    move $s7, $t7
                    move $s6, $a3
                    j winCheck

    playerTwoRemove:
        lw $s2, boardGame($t7)
        beq $s2, 1, removeTrue_Two
        removeFalse_Two:
            la $a0, removeFalse
            li $v0, 4
            syscall
            j removeProgress

        removeTrue_Two:
            sw $zero, boardGame($t7)
            li $t7, 0
            la $a3, removePlayerTwo
            sw $t7, ($a3)

            # #check if index = winChance
            # li $s0, 0
            # lw $t7, index_WinChance_1($s0)
            # beq $s1, $t7, resetIndex_2

            # addi $s0, $s0, 4
            # lw $t7, index_WinChance_1($s0)
            # beq $s1, $t7, resetIndex_2
            
            # addi $s0, $s0, 4
            # lw $t7, index_WinChance_1($s0)
            # beq $s1, $t7, resetIndex_2
            # j noReset_2

            # resetIndex_2:    
            #     la $s0, index_WinChance_1
            #     li $t7, 1
            #     sw $t7, 0($s0)
            #     sw $t7, 4($s0)
            #     sw $t7, 8($s0)
            #     sw $t7, 12($s0)
            #     la $s0, jumpWinCheckFromRemove
            #     sw $t7, ($s0)
            #     la $s0, winChance_PlayerOne
            #     li $t7, 0
            #     sw $t7, ($s0)

            # noReset_2:
            li $t7, 1
            la $s0, jumpWinCheckFromRemove
            sw $t7, ($s0)

            move $t7, $s1
            innerFalling_Two:
                addi $a3, $t7, 28
                bgt $a3, 168, outFalling_Two
                lw $a2, boardGame($a3)
                sw $a2, boardGame($t7)
                addi $t7, $t7, 28
                j innerFalling_Two

            outFalling_Two:
                subi $a3, $a3, 28
                sw $zero, boardGame($a3)
                subi $a3, $a3, 168

                # each falling-index winCheck
                lw $s0, jumpWinCheckFromRemove
                beq $s0, 1, eachCheckTwo
                finishRemoveCheck_2:
                    sw $zero, jumpWinCheckFromRemove
                    jal winChanceUpdate
                    jal boardGamePrint_Temp
                    li $s7, 2
                    j playerTwoAsk_Block
                
                eachCheckTwo:
                    addi $a3, $a3, 28

                    # give true value to $a0, save temp $s7 to $s0
                    move $s0, $s7
                    lw $t7, boardGame($a3)
                    bgt $a3, 168, finishRemoveCheck_2
                    beq $t7, 0, eachCheckTwo
                    
                    move $s7, $t7
                    move $s6, $a3
                    j winCheck
################# END #################
            
            
################# !STORE DATA #################
StoreData:
    beq $a0, 1, firstTurnOne
    beq $a0, 2, firstTurnTwo

    firstTurnOne:
        lw $t1, firstOne
        beq $t1, 0, midGame
        bne $v0, '4', invalidData
        la $t1, firstOne
        sw $zero, ($t1)
        j controlData

    firstTurnTwo:    
        lw $t1, firstTwo
        beq $t1, 0, midGame
        bne $v0, '4', invalidData
        la $t1, firstTwo
        sw $zero, ($t1)
        j controlData

    midGame:
    blt $v0, '1', invalidData
    bgt $v0, '7', invalidData
    controlData:
    subi $v0, $v0, 48
    addi $v0, $v0, -1
    move $t1, $v0
    add $v0, $v0, $t1
    add $v0, $v0, $t1
    add $v0, $v0, $t1
    lb $t1, boardGame($v0)
    beq $t1, 0, addPieces

    columnFullCheck:
        addiu $v0, $v0, 28
        bgtu $v0, 164, columnFull
        lw $t1, boardGame($v0)	
        bnez $t1, columnFullCheck

        # If column can be added
        addPieces:
            sw $a0, boardGame($v0)
            move $s7, $a0
            move $s6, $v0
            j boardGamePrint

    invalidData:
        move $t0, $a0
        la $a0, invalidDataText
        li $v0, 4
        syscall

        move $a0, $t0
        j faultIncrease

    columnFull:
        move $t0, $a0
        la $a0, ColumnFullCommand
        li $v0, 4
        syscall
        move $a0, $t0
        # beq $a0, 1, playerOneTurn
        j faultIncrease

    faultIncrease:
        beq $a0, 1, playerOne_MakeFault
        beq $a0, 2, playerTwo_MakeFault

	playerOne_MakeFault:
        addi $t5, $t5, 1
        beq $t5, 3, playerOne_FullFault
        li $s7, 2
        j rePrint

	playerTwo_MakeFault:
        addi $t6,$t6,1
        beq $t6, 3, playerTwo_FullFault
        li $s7, 1
        j rePrint
	
	playerOne_FullFault:
        la $a0, violationMax1
        li $v0, 4
        syscall
        j playerTwoWin

    playerTwo_FullFault:
        la $a0, violationMax2
        li $v0, 4
        syscall
        j playerOneWin
################# END #################


################# ! CONNECT FOUR CHECK #################
winCheck:    	
    move $a0, $s7
    move $v0, $s6
    li $t8, 28		
    
    #-----------------Check horizontal-----------------#
    

    jal getChance
    beq $t9, 1, temp_H
    jal getAddressIndex
    li $t9, 1		
    move $t2, $v0		
    move $t4, $v0	
    j checkLeft

    temp_H:
        la $t7, tempIndex
        li $t9, 1		
        move $t2, $v0		
        move $t4, $v0	
    

    checkLeft:
        la $t0, boardGame($t2)	
        #t0 = Array[v0]
        div $t2, $t8
        mfhi $t3		
        beqz $t3, checkRight	
        
        lw $t1, -4($t0)			
        bne $t1, $a0, checkRight	
        addiu $t9, $t9, 1
        addi $t7, $t7, 4		
        addiu $t2, $t2, -4
        sw $t2, ($t7)
        bgt $t9, 3, PlayerWon		
        j checkLeft
     	
	checkRight:
        la $t0, boardGame($t4)

        div $t4, $t8
        mfhi $t3
        beq $t3, 24, endHorz	

        lw $t1, 4($t0)		
        bne $t1, $a0, endHorz	
        addiu $t9, $t9, 1
        addi $t7, $t7, 4	
        addiu $t4, $t4, 4
        sw $t4, ($t7)
        bgt $t9, 3, PlayerWon	
        j checkRight
	
	endHorz:
        beq $t9, 3, winChance_Horizontal
        
        jal getChance
        beq $t9, 1, verticalCheck
        j reset_WinChance_H

        winChance_Horizontal:
            jal getAddressIndex
            sw $v0, ($t7)
            beq $s7, 1, winChance_Horizontal_One
            beq $s7, 2, winChance_Horizontal_Two
            j verticalCheck
            winChance_Horizontal_One:
                li $t9, 1
                sw $t9, winChance_PlayerOne
                j verticalCheck
            winChance_Horizontal_Two:
                li $t9, 1
                sw $t9, winChance_PlayerTwo
                j verticalCheck

        reset_WinChance_H:
            jal getAddressIndex
            li $t9, 1
            sw $t9, 0($t7)
            sw $t9, 4($t7)
            sw $t9, 8($t7)
            sw $t9, 12($t7)
            j verticalCheck


        
            
	#-----------------End Horizontal Check-----------------#
	
     	
     	#-----------------Check vertical-----------------#
    verticalCheck:
     	li $t9, 1		
        move $t2, $v0		
        move $t4, $v0
        
        jal getChance
        beq $t9, 1, temp_V
        jal getAddressIndex
        li $t9, 1		
        move $t2, $v0		
        move $t4, $v0
        j checkUp

        temp_V:
            la $t7, tempIndex
            li $t9, 1		
            move $t2, $v0		
            move $t4, $v0

        checkUp:
            la $t0, boardGame($t2)	
            
            bgtu $t2, 136, checkDown	
            
            lw $t1, 28($t0)			
            bne $t1, $a0, checkDown		
            addiu $t9, $t9, 1		
            addi $t7, $t7, 4
            addiu $t2, $t2, 28
            addi $t2, $t2, 28
            sw $t2, ($t7)
            subi $t2, $t2, 28
            bgt $t9, 3, PlayerWon		
            j checkUp

        checkDown:
            la $t0, boardGame($t4)

            bltu $t4, 28, endVert
            
            lw $t1, -28($t0)		
            bne $t1, $a0, endVert	
            addiu $t9, $t9, 1
            addi $t7, $t7, 4	
            addiu $t4, $t4, -28	
            subi $t4, $t4, 28
            sw $t4, ($t7)
            addi $t4, $t4, 28
            bgt $t9, 3, PlayerWon	
            j checkDown
	
	endVert:  
        beq $t9, 3, winChance_Vertical

        jal getChance
        beq $t9, 1, FSCheck
        j reset_WinChance_V

        winChance_Vertical:
            jal getAddressIndex
            sw $v0, ($t7)
            beq $s7, 1, winChance_Vertical_One
            beq $s7, 2, winChance_Vertical_Two
            j FSCheck
            winChance_Vertical_One:
                li $t9, 1
                sw $t9, winChance_PlayerOne
                j FSCheck
            winChance_Vertical_Two:
                li $t9, 1
                sw $t9, winChance_PlayerTwo
                j FSCheck

        reset_WinChance_V:
            jal getAddressIndex
            li $t9, 1
            sw $t9, 0($t7)
            sw $t9, 4($t7)
            sw $t9, 8($t7)
            sw $t9, 12($t7)
            j FSCheck

     	#-----------------End Vertical Check-----------------#
     	
     	
     	#-----------------Check forward-slash diagonal-----------------#
    FSCheck:
        li $t9, 1		
        move $t2, $v0		
        move $t4, $v0		

        jal getChance
        beq $t9, 1, temp_FS
        jal getAddressIndex
        li $t9, 1		
        move $t2, $v0		
        move $t4, $v0
        j checkUR

        temp_FS:
            la $t7, tempIndex
            li $t9, 1		
            move $t2, $v0		
            move $t4, $v0

        checkUR:
            la $t0, boardGame($t2)	
            
            bgtu $t2, 136, checkDL	
            div $t2, $t8
            mfhi $t3
            beq $t3, 6, checkDL	
            

            lw $t1, 32($t0)			
            bne $t1, $a0, checkDL		
            addiu $t9, $t9, 1
            addi $t7, $t7, 4		
            addiu $t2, $t2, 32
            addi $t2, $t2, 32
            sw $t2, ($t7)
            subi $t2, $t2, 32
            bgt $t9, 3, PlayerWon		
            j checkUR
     	
        checkDL:
            la $t0, boardGame($t4)
            
            bltu $t4, 28, endFSDiag	
            div $t4, $t8
            mfhi $t3
            beq $t3, 0, endFSDiag	
            
            lw $t1, -32($t0)		
            bne $t1, $a0, endFSDiag	
            addiu $t9, $t9, 1
            addi $t7, $t7, 4	
            addiu $t4, $t4, -32	
            subi $t4, $t4, 32
            sw $t4, ($t7)
            addi $t4, $t4, 32
            bgt $t9, 3, PlayerWon	
            j checkDL
            
	endFSDiag:  
        beq $t9, 3, winChance_FS

        jal getChance
        beq $t9, 1, BSCheck
        j reset_WinChance_FS

        winChance_FS:
            jal getAddressIndex
            sw $v0, ($t7)
            beq $s7, 1, winChance_FS_One
            beq $s7, 2, winChance_FS_Two
            j BSCheck
            winChance_FS_One:
                li $t9, 1
                sw $t9, winChance_PlayerOne
                j BSCheck
            winChance_FS_Two:
                li $t9, 1
                sw $t9, winChance_PlayerTwo
                j BSCheck

        reset_WinChance_FS:
            jal getAddressIndex
            li $t9, 1
            sw $t9, 0($t7)
            sw $t9, 4($t7)
            sw $t9, 8($t7)
            sw $t9, 12($t7)
            j BSCheck

     	#-----------------End Forward-Slash Diagonal Check-----------------#
     	
     	
     	#-----------------Check backward-slash diagonal-----------------#
    BSCheck:	
     	li $t9, 1		
        move $t2, $v0		
        move $t4, $v0

        jal getChance
        beq $t9, 1, temp_BS
        jal getAddressIndex
        li $t9, 1		
        move $t2, $v0		
        move $t4, $v0
        j checkUL

        temp_BS:
            la $t7, tempIndex
            li $t9, 1		
            move $t2, $v0		
            move $t4, $v0

        checkUL:
            la $t0, boardGame($t2)	
            
            bgtu $t2, 136, checkDR	
            div $t2, $t8
            mfhi $t3
            beq $t3, 0, checkDR	
            
            lw $t1, 24($t0)			
            bne $t1, $a0, checkDR		
            addiu $t9, $t9, 1
            addi $t7, $t7, 4		
            addiu $t2, $t2, 24
            addi $t2, $t2, 24
            sw $t2, ($t7)
            subi $t2, $t2, 24
            bgt $t9, 3, PlayerWon		
            j checkUL
     	
        checkDR:
            la $t0, boardGame($t4)
            
            bltu $t4, 28, endBSDiag	
            div $t4, $t8
            mfhi $t3
            beq $t3, 24, endBSDiag	
	
	
            lw $t1, -24($t0)		
            bne $t1, $a0, endBSDiag	
            addiu $t9, $t9, 1
            addi $t7, $t7, 4	
            addiu $t4, $t4, -24
            subi $t4, $t4, 24
            sw $t0, ($t7)
            addi $t4, $t4, 24
            bgt $t9, 3, PlayerWon	
            j checkDR
	
	endBSDiag:     	
        beq $t9, 3, winChance_BS 
        
        jal getChance
        beq $t9, 1, fullBoard
        j reset_WinChance_BS

        winChance_BS:
            jal getAddressIndex
            sw $v0, ($t7)
            beq $s7, 1, winChance_BS_One
            beq $s7, 2, winChance_BS_Two
            j fullBoard
            winChance_BS_One:
                li $t9, 1
                sw $t9, winChance_PlayerOne
                j fullBoard
            winChance_BS_Two:
                li $t9, 1
                sw $t9, winChance_PlayerTwo
                j fullBoard

        reset_WinChance_BS:
            jal getAddressIndex
            li $t9, 1
            sw $t9, 0($t7)
            sw $t9, 4($t7)
            sw $t9, 8($t7)
            sw $t9, 12($t7)
            j fullBoard

     	#-----------------End Backward-Slash Diagonal Check-----------------#
     	
     	#-----------------Start Full Board Check-----------------#
    fullBoard:
     	li $t9, 140		
     	la $t0, boardGame($t9)
     	
     	li $t2, 0		
    	checkTop:
            lw $t1, ($t0)
            beqz $t1, endTie	
            addi $t0, $t0, 4
            add $t2, $t2, 1	
            beq $t2, 7, drawGame	
            j checkTop	
    
    	endTie:
     	#-----------------End Full Board Check-----------------#
            lw $t9, jumpWinCheckFromRemove
            beq $t9, 1, backToRemove
            j afterCheck
            backToRemove:
                move $s7, $s0 # reset $s7
                beq $s7, 1, eachCheckTwo
                beq $s7, 2, eachCheckOne
################# END #################


################# TODO: DRAW #################
drawGame:
    la $a0, tieGame
	li $v0, 4
	syscall
    jal boardGamePrint_Temp
    la $a0, endGame
    li $v0, 4
    syscall
	li $v0, 10
	syscall
################# END #################


################# ! WIN #################
PlayerWon:
	beq $a0, 1, playerOneWin	
    beq $a0, 2, playerTwoWin
    
	playerTwoWin:
        li $t0, 0
        li $t1, 0
        calPieces_Two:
            lw $t2, boardGame($t1)
            beq $t2, 2, addTwo
            addi $t1, $t1, 4
            beq $t1, 168, printTwoWin
            j calPieces_Two
            addTwo:
                addi $t0, $t0, 1
                addi $t1, $t1, 4
                beq $t1, 168, printTwoWin
                j calPieces_Two
        
        printTwoWin:
            la $a0, winner
            li $v0, 4
            syscall
            la $a0, winner2
            li $v0, 4
            syscall
            la $a0, playerWinner
            li $v0, 4
            syscall
            la $a0, playerTwoName
            li $v0, 4
            syscall
            la $a0, printPiece
            li $v0, 4
            syscall
            move $a0, $k1
            li $v0, 4
            syscall
            la $a0, numPieces
            li $v0, 4
            syscall
            move $a0, $t0
            li $v0, 1
            syscall
            jal boardGamePrint_Temp
            la $a0, endGame
            li $v0, 4
            syscall
            li $v0, 10
            syscall
	
	playerOneWin:
        li $t0, 0
        li $t1, 0
        calPieces_One:
            lw $t2, boardGame($t1)
            beq $t2, 1, addOne

            addi $t1, $t1, 4
            beq $t1, 168, printOneWin
            j calPieces_One
            addOne:
                addi $t0, $t0, 1
                addi $t1, $t1, 4
                beq $t1, 168, printOneWin
                j calPieces_One

        printOneWin:
            la $a0, winner
            li $v0, 4
            syscall
            la $a0, winner1
            li $v0, 4
            syscall
            la $a0, playerWinner
            li $v0, 4
            syscall
            la $a0, playerOneName
            li $v0, 4
            syscall
            la $a0, printPiece
            li $v0, 4
            syscall
            move $a0, $k0
            li $v0, 4
            syscall
            la $a0, numPieces
            li $v0, 4
            syscall
            move $a0, $t0
            li $v0, 1
            syscall
            jal boardGamePrint_Temp
            la $a0, endGame
            li $v0, 4
            syscall
            li $v0, 10
            syscall
################# END #################

################# *PRINT BOARD _ TEMP #################
boardGamePrint_Temp:
    la $a0, endl
    li $v0, 4
    syscall
    la $a0, boardText
    li $v0, 4
    syscall
    la $a0, columnNumber
    li $v0, 4
    syscall

    ########## LINE 1 ##########
    li $s1, 168
    li $s0, 140
    la $a0, one
    li $v0, 4
    syscall
    Row1_Temp:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_1_Temp
        beq $s2, 1, printPlayerOne_1_Temp
        beq $s2, 2, printPlayerTwo_1_Temp
    
    printEmpty_1_Temp:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R1_Temp
    
    printPlayerOne_1_Temp:
        move $a0, $k0
        li $v0, 4
        syscall
        j R1_Temp
    
    printPlayerTwo_1_Temp:
        move $a0, $k1
        li $v0, 4
        syscall
        j R1_Temp
    
    R1_Temp:
        addi $s0, $s0, 4
        bne $s0, $s1, Row1_Temp

        la $a0, newline	
        li $v0, 4
        syscall
    
    ########## LINE 2 ##########
    li $s1, 140
    li $s0, 112
    la $a0, two
    li $v0, 4
    syscall
    Row2_Temp:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_2_Temp
        beq $s2, 1, printPlayerOne_2_Temp
        beq $s2, 2, printPlayerTwo_2_Temp
    
    printEmpty_2_Temp:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R2_Temp
    
    printPlayerOne_2_Temp:
        move $a0, $k0
        li $v0, 4
        syscall
        j R2_Temp
    
    printPlayerTwo_2_Temp:
        move $a0, $k1
        li $v0, 4
        syscall
        j R2_Temp
    
    R2_Temp:
        addi $s0, $s0, 4
        bne $s0, $s1, Row2_Temp

        la $a0, newline	
        li $v0, 4
        syscall

    ########## LINE 3 ##########
    li $s1, 112
    li $s0, 84
    la $a0, three
    li $v0, 4
    syscall
    Row3_Temp:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_3_Temp
        beq $s2, 1, printPlayerOne_3_Temp
        beq $s2, 2, printPlayerTwo_3_Temp
    
    printEmpty_3_Temp:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R3_Temp
    
    printPlayerOne_3_Temp:
        move $a0, $k0
        li $v0, 4
        syscall
        j R3_Temp
    
    printPlayerTwo_3_Temp:
        move $a0, $k1
        li $v0, 4
        syscall
        j R3_Temp
    
    R3_Temp:
        addi $s0, $s0, 4
        bne $s0, $s1, Row3_Temp

        la $a0, newline	
        li $v0, 4
        syscall

    ########## LINE 4 ##########
    li $s1, 84
    li $s0, 56
    la $a0, four
    li $v0, 4
    syscall
    Row4_Temp:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_4_Temp
        beq $s2, 1, printPlayerOne_4_Temp
        beq $s2, 2, printPlayerTwo_4_Temp
    
    printEmpty_4_Temp:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R4_Temp
    
    printPlayerOne_4_Temp:
        move $a0, $k0
        li $v0, 4
        syscall
        j R4_Temp
    
    printPlayerTwo_4_Temp:
        move $a0, $k1
        li $v0, 4
        syscall
        j R4_Temp
    
    R4_Temp:
        addi $s0, $s0, 4
        bne $s0, $s1, Row4_Temp

        la $a0, newline	
        li $v0, 4
        syscall
    
    ########## LINE 5 ##########
    li $s1, 56
    li $s0, 28
    la $a0, five
    li $v0, 4
    syscall
    Row5_Temp:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_5_Temp
        beq $s2, 1, printPlayerOne_5_Temp
        beq $s2, 2, printPlayerTwo_5_Temp
    
    printEmpty_5_Temp:
        la $a0,emptyPiece
        li $v0, 4
        syscall
        j R5_Temp
    
    printPlayerOne_5_Temp:
        move $a0, $k0
        li $v0, 4
        syscall
        j R5_Temp
    
    printPlayerTwo_5_Temp:
        move $a0, $k1
        li $v0, 4
        syscall
        j R5_Temp
    
    R5_Temp:
        addi $s0, $s0, 4
        bne $s0, $s1, Row5_Temp

        la $a0, newline	
        li $v0, 4
        syscall

    ########## LINE 6 ##########
    li $s1, 28
    li $s0, 0
    la $a0, six
    li $v0, 4
    syscall
    Row6_Temp:
        lw $s2, boardGame($s0)
        beq $s2, 0, printEmpty_6_Temp
        beq $s2, 1, printPlayerOne_6_Temp
        beq $s2, 2, printPlayerTwo_6_Temp
    
    printEmpty_6_Temp:
        la $a0, emptyPiece
        li $v0, 4
        syscall
        j R6_Temp
    
    printPlayerOne_6_Temp:
        move $a0, $k0
        li $v0, 4
        syscall
        j R6_Temp
    
    printPlayerTwo_6_Temp:
        move $a0, $k1
        li $v0, 4
        syscall
        j R6_Temp
    
    R6_Temp:
        addi $s0, $s0, 4
        bne $s0, $s1, Row6_Temp

        la $a0, newline	
        li $v0, 4
        syscall

    jr $ra
################# END #################


################# REPRINT INFO - UNDO #################
rePrint:    	
    la $a0, gameAnnounce
    li $v0, 4
    syscall

    beq $s7, 1, getName_playerTwo_temp
    beq $s7, 2, getName_playerOne_temp
    
    getName_playerOne_temp:
        la $a0, playerTurnOne
        li $v0, 4
        syscall
        la $a0, playerOneName
        li $v0, 4
        syscall
        la $a0, hyphen
        li $v0, 4
        syscall
        lw $t7, typePlayerOne
        beq $t7, 1, printX_temp
        printO_temp:
            la $a0, O_piece
            li $v0, 4
            syscall
            j moreInfo_1_temp
        printX_temp: 
            la $a0, X_piece
            li $v0, 4
            syscall
            j moreInfo_1_temp
        
        moreInfo_1_temp:
        la $a0, faultCount
        li $v0, 4
        syscall
        move $a0, $t5
        li $v0, 1
        syscall
        la $a0, undoCount
        li $v0, 4
        syscall
        move $a0, $s3
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall
        j dropInto_temp

    getName_playerTwo_temp:
        la $a0, playerTurnTwo
        li $v0, 4
        syscall
        la $a0, playerTwoName
        li $v0, 4
        syscall
        la $a0, hyphen
        li $v0, 4
        syscall
        lw $t7, typePlayerTwo
        beq $t7, 1, printX_2_temp
        printO_2_temp:
            la $a0, O_piece
            li $v0, 4
            syscall
            j moreInfo_2_temp

        printX_2_temp:
            la $a0, X_piece
            li $v0, 4
            syscall
            j moreInfo_2_temp
        
        moreInfo_2_temp:
        la $a0, faultCount
        li $v0, 4
        syscall
        move $a0, $t6
        li $v0, 1
        syscall
        la $a0, undoCount
        li $v0, 4
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
        la $a0, newline
        li $v0, 4
        syscall

        j dropInto_temp
    
    dropInto_temp:
        la $a0, requestDrop
        li $v0, 4
        syscall
        la $v0, 12
        syscall

    beq $s7, 1, storeTwo
    beq $s7, 2, storeOne
################# END #################






getAddressIndex:
    beq $s7, 1, getAddressIndexOne
    la $t7, index_WinChance_2
    jr $ra
    getAddressIndexOne:
        la $t7, index_WinChance_1
        jr $ra

getChance:
    beq $s7, 1, getChanceOne
    lw $t9, winChance_PlayerTwo
    jr $ra
    getChanceOne:
        lw $t9, winChance_PlayerOne
        jr $ra


winChanceUpdate:
    lw $a3, winChance_PlayerOne
    beq $a3, 0, phaseTwo

    la $a3, index_WinChance_1
    lw $s1, ($a3)
    lw $t7, boardGame($s1)
    move $s2, $t7

    lw $s1, 4($a3)
    lw $t7, boardGame($s1)
    bne $s2, $t7, noChanceOne

    lw $s1, 8($a3)
    lw $t7, boardGame($s1)
    bne $s2, $t7, noChanceOne
    j phaseTwo

    noChanceOne:
        la $s0, index_WinChance_1
        li $t7, 1
        sw $t7, 0($s0)
        sw $t7, 4($s0)
        sw $t7, 8($s0)
        sw $t7, 12($s0)
        sw $zero, winChance_PlayerOne

    phaseTwo:
        lw $a3, winChance_PlayerTwo
        beq $a3, 0, outCheck

        la $a3, index_WinChance_2
        lw $s1, ($a3)
        lw $t7, boardGame($s1)
        move $s2, $t7

        lw $s1, 4($a3)
        lw $t7, boardGame($s1)
        bne $s2, $t7, noChanceTwo
        
        lw $s1, 8($a3)
        lw $t7, boardGame($s1)
        bne $s2, $t7, noChanceTwo
        jr $ra

        noChanceTwo:
            la $s0, index_WinChance_2
            li $t7, 1
            sw $t7, 0($s0)
            sw $t7, 4($s0)
            sw $t7, 8($s0)
            sw $t7, 12($s0)
            sw $zero, winChance_PlayerTwo

    outCheck:
        jr $ra
