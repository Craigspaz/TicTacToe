## Tic Tac Toe
## Craig Ferris

.data
initmessage: .asciiz "Initializing Tic Tac Toe\n"
player1Message: .asciiz "Player X make a move [0-8]:\n"
player2Message: .asciiz "Player O make a move [0-8]:\n"
inputErrorMessage: .asciiz "Input error! Input out of range!\n"
player1WinsMessage: .asciiz "Player O Wins!\n"
player2WinsMessage: .asciiz "Player X Wins!\n"
board: .word 0,0,0, 0,0,0, 0,0,0 # store the board
.text

# Print initialization message
la $a0, initmessage
jal printMessage
L1:
	jal nextIteration # next round of the game
	jal checkWinConditions # checks to see if anyone one
j L1
li $v0, 10
syscall

# Implements the next round of the game
nextIteration:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal displayBoard
	
	la $a0, player1Message
	jal printMessage
	
	# Get input from player 1
	li $v0, 5
	syscall
	
	# Check input to make sure it is valid
	blt $v0, 0, inputError
	bgt $v0, 8, inputError
	beq $v0, 0, skipAddressCalc
	
	# store valid input
	sll $v0, $v0, 2
	skipAddressCalc:
		la $t0, board
		li $t1, 88
		add $t2, $t0, $v0
		lw $t3, 0($t2)
		bne $t3, 0, inputError
		sw $t1, 0($t2)
	
	# prepare for player O
	jal displayBoard
	jal checkWinConditions
	la $a0, player2Message
	jal printMessage
	
	# get player O input
	li $v0, 5
	syscall
	
	# Check input to make sure it is valid
	blt $v0, 0, inputError
	bgt $v0, 8, inputError
	beq $v0, 0, skipAddressCalc1
	
	# Store input
	sll $v0, $v0, 2
	skipAddressCalc1:
		la $t0, board
		li $t1, 79
		add $t2, $t0, $v0
		lw $t3, 0($t2)
		bne $t3, 0, inputError
		sw $t1, 0($t2)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# Displays the game board
displayBoard:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, board
	
	li $t1, 0
	loop1:
		bge $t1, 9, doneLoop1
		
		sll $t2, $t1, 2 # multiplies by 4
		add $t3, $t2, $t0 # calculate address to read
		lw $t4, 0($t3)
		
		bnez $t4, contCheck
		# if equal to zero draw blank
		li $v0, 1
		move $a0, $t1
		syscall
		j doneCheck
		
		contCheck:
		li $v0, 11
		move $a0, $t4
		syscall
		doneCheck:
		
		#decide if walls need to be drawn
		bgt $t1, 1, nl
		li $v0, 11
		li $a0, 124
		syscall
		j doneN
		nl:
		bgt $t1, 2, n2
		li $v0, 11
		li $a0, 10
		syscall
		j doneN
		n2:
		bgt $t1, 4, n3
		li $v0, 11
		li $a0, 124
		syscall
		j doneN
		n3:
		bgt $t1, 5, n4
		li $v0, 11
		li $a0, 10
		syscall
		j doneN
		n4:
		bgt $t1, 7, n5
		li $v0, 11
		li $a0, 124
		syscall
		j doneN
		n5:
		li $v0, 11
		li $a0, 10
		syscall
		doneN:	
		
		addi $t1, $t1, 1
		j loop1
	doneLoop1:
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	jr $ra
	
# Put address of string you want to print in $a0
printMessage:
	li $v0, 4
	syscall
	jr $ra

# Checks to see if someone won
checkWinConditions:
	la $t0, board
	
	#three across top
	lw $t1, ($t0)
	lw $t2, 4($t0)
	lw $t3, 8($t0)
	bne $t1, $t2, nextCheck
	bne $t2, $t3, nextCheck
	beq $t2, 88, player2Wins
	bne $t2, 79, nextCheck
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck:
	#three across middle
	lw $t1, 12($t0)
	lw $t2, 16($t0)
	lw $t3, 20($t0)
	bne $t1, $t2, nextCheck1
	bne $t2, $t3, nextCheck1
	beq $t2, 88, player2Wins1
	bne $t2, 79, nextCheck1
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins1:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck1:
	#three across bottom
	lw $t1, 24($t0)
	lw $t2, 28($t0)
	lw $t3, 32($t0)
	bne $t1, $t2, nextCheck2
	bne $t2, $t3, nextCheck2
	beq $t2, 88, player2Wins2
	bne $t2, 79, nextCheck2
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins2:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck2:
	#three down left
	lw $t1, 0($t0)
	lw $t2, 12($t0)
	lw $t3, 24($t0)
	bne $t1, $t2, nextCheck3
	bne $t2, $t3, nextCheck3
	beq $t2, 88, player2Wins3
	bne $t2, 79, nextCheck3
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins3:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck3:
	#three down middle
	lw $t1, 4($t0)
	lw $t2, 16($t0)
	lw $t3, 28($t0)
	bne $t1, $t2, nextCheck4
	bne $t2, $t3, nextCheck4
	beq $t2, 88, player2Wins4
	bne $t2, 79, nextCheck4
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins4:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck4:
	#three down right
	lw $t1, 8($t0)
	lw $t2, 20($t0)
	lw $t3, 32($t0)
	bne $t1, $t2, nextCheck5
	bne $t2, $t3, nextCheck5
	beq $t2, 88, player2Wins5
	bne $t2, 79, nextCheck5
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins5:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck5:
	#three diagnal \
	lw $t1, 0($t0)
	lw $t2, 16($t0)
	lw $t3, 32($t0)
	bne $t1, $t2, nextCheck6
	bne $t2, $t3, nextCheck6
	beq $t2, 88, player2Wins6
	bne $t2, 79, nextCheck6
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins6:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck6:
	#three diagnal /
	lw $t1, 8($t0)
	lw $t2, 16($t0)
	lw $t3, 24($t0)
	bne $t1, $t2, nextCheck7
	bne $t2, $t3, nextCheck7
	beq $t2, 88, player2Wins7
	bne $t2, 79, nextCheck7
	la $a0, player1WinsMessage
	j printWinMessage
	player2Wins7:
	bne $t2, 88, nextCheck
	la $a0, player2WinsMessage
	j printWinMessage
	
	nextCheck7:
	
	jr $ra

# Jumps here if there is an error	
inputError:
	la $a0, inputErrorMessage
printWinMessage:
jal printMessage
li $v0, 10
syscall
