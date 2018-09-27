#Registers Used
#
#	$s0 - Level chosen
#	$s6 - File descriptor
#	$s7 - Total blanks remaining



.data
	pitch1: .byte 69
	duration: .byte 1000
	instrument: .byte 24
	volume: .byte 127
	time: .byte 1000

	
	file1: .asciiz "1.txt"
	file2: .asciiz "2.txt"
	file3: .asciiz "3.txt"
	file4: .asciiz "4.txt"
	file5: .asciiz "5.txt"
	file6: .asciiz "6.txt"
	file7: .asciiz "7.txt"
	file8: .asciiz "8.txt"
	file9: .asciiz "9.txt"
	file10: .asciiz "10.txt"
	
	under: 		.ascii "_"
	nextline: 	.asciiz "\n"
	space12: 	.asciiz "            "
	space10: 	.asciiz "          "
	space8: 	.asciiz "        "
	space6: 	.asciiz "      "
	space4: 	.asciiz "    "
	space2: 	.asciiz "  "
	space1: 	.asciiz " "

	alphabet: 	.asciiz "ABCDEFGHIJKLMNOPQRST"

	description: 	.asciiz "\nThe number tower is a fun kid's puzzle that is a great test of maths skills but in a fun way. \nThe puzzle starts with a tower that has some numbers placed and others are empty. \nThe aim of the puzzle is to fill in the missing values and complete the puzzle. \nEach number is the sum of the two numbers beneath it in the tower puzzle. \nUsing logic and maths ability, every puzzle can be created without guessing. \nWhen choosing a box, please only enter characters that correspond to empty boxes!"
	startMenu: 		.asciiz "\n\nEnter the number of the level you would like to play, from levels 1 to 5 (higher = harder): "
	levelChoiceError: 	.asciiz "\nThat is not a valid level, please input a valid level number\n"
	boxPrompt: 		.asciiz "\nWhat box would you like to guess for? (1 char max): "
	boxErrorResponse: 	.asciiz "\nInvalid box selection"
	guessPrompt: 		.asciiz "\nWhat would number you like to guess? (3 num max): "
	rightResponse: 		.asciiz "\nCorrect!"
	wrongResponse: 		.asciiz "\nIncorrect!"
	winningResponse: 	.asciiz "\nCongratulations! Tower completed!"
	againPrompt: 		.asciiz "\nWould you like to play again? (1 for yes, anything else for no): "
	
	p01: .space 5
	p02: .space 5
	p03: .space 5
	p04: .space 5
	p05: .space 5
	p06: .space 5
	p07: .space 5
	p08: .space 5
	p09: .space 5
	p10: .space 5
	p11: .space 5
	p12: .space 5
	p13: .space 5
	p14: .space 5
	p15: .space 5
	p16: .space 5
	p17: .space 5
	p18: .space 5
	p19: .space 5
	p20: .space 5
	p21: .space 5
	p22: .space 5
	p23: .space 5
	p24: .space 5
	p25: .space 5
	p26: .space 5
	p27: .space 5
	p28: .space 5
	
	aA: .space 4
	aB: .space 4
	aC: .space 4
	aD: .space 4
	aE: .space 4
	aF: .space 4
	aG: .space 4
	aH: .space 4
	aI: .space 4
	aJ: .space 4
	aK: .space 4
	aL: .space 4
	aM: .space 4
	aN: .space 4
	aO: .space 4
	aP: .space 4
	
	gA: .space 4
	gB: .space 4
	gC: .space 4
	gD: .space 4
	gE: .space 4
	gF: .space 4
	gG: .space 4
	gH: .space 4
	gI: .space 4
	gJ: .space 4
	gK: .space 4
	gL: .space 4
	gM: .space 4
	gN: .space 4
	gO: .space 4
	gP: .space 4
	
	tempOneDigit: .asciiz "00_"
	tempTwoDigit: .asciiz "0__"
	
.text

main: 
	#print description
	li $v0, 4
	la $a0, description 
	syscall

newGame:
	#print start menu
	li $v0, 4
	la $a0, startMenu
	syscall

menu:
	#pass in menu choice 
	li $v0, 5
	syscall
	bgt $v0, 5, menuError
	
	move $s0, $v0	#copy level choice to $s0
	
	li $v0, 42
	li $a1, 10
	syscall
	add $a0, $a0, 1
	
	beq $a0, 1, openFile1
	beq $a0, 2, openFile2
	beq $a0, 3, openFile3
	beq $a0, 4, openFile4
	beq $a0, 5, openFile5
	beq $a0, 6, openFile6
	beq $a0, 7, openFile7
	beq $a0, 8, openFile8
	beq $a0, 9, openFile9
	beq $a0, 10, openFile10
	
	j menu

menuError:	
	li  $v0, 4
 	la $a0, levelChoiceError
 	syscall
 	
 	j menu	

processFile:
	#Read in all characters into display vars
	li $v0, 14
	move $a0, $s6
	la $a1, p01
	li $a2, 140
	syscall
	
	li $t0, 28
	la $t1, p01
	li $t2, 0x00
	
nullTermLoop:
	sb $t2, 3($t1)
	add $t1, $t1, 5
	add $t0, $t0, -1
	beqz $t0, fileClose
	j nullTermLoop	
	
fileClose:	
	#Closes file
	li $v0, 16
	move $a0, $s6
	syscall
	
	jal setVariables
	
	add $s7, $s0, 11
	
	j guessLoop
	
guessLoop:
	jal print
	
	#Ask user what box they want to edit
	li $v0, 4
	la $a0, boxPrompt
	syscall
	
	li $v0, 12
	syscall
	move $t0, $v0
	
	#Validate that
	
	beq $t0, 0x41, checkA
	beq $t0, 0x61, checkA
	
	beq $t0, 0x42, checkB
	beq $t0, 0x62, checkB
	
	beq $t0, 0x43, checkC
	beq $t0, 0x63, checkC
	
	beq $t0, 0x44, checkD
	beq $t0, 0x64, checkD
	
	beq $t0, 0x45, checkE
	beq $t0, 0x65, checkE
	
	beq $t0, 0x46, checkF
	beq $t0, 0x66, checkF
	
	beq $t0, 0x47, checkG
	beq $t0, 0x67, checkG
	
	beq $t0, 0x48, checkH
	beq $t0, 0x68, checkH
	
	beq $t0, 0x49, checkI
	beq $t0, 0x69, checkI
	
	beq $t0, 0x4A, checkJ
	beq $t0, 0x6A, checkJ
	
	beq $t0, 0x4B, checkK
	beq $t0, 0x6B, checkK
	
	beq $t0, 0x4C, checkL
	beq $t0, 0x6C, checkL
	
	beq $t0, 0x4D, checkM
	beq $t0, 0x6D, checkM
	
	beq $t0, 0x4E, checkN
	beq $t0, 0x6E, checkN
	
	beq $t0, 0x4F, checkO
	beq $t0, 0x6F, checkO
	
	beq $t0, 0x50, checkP
	beq $t0, 0x70, checkP

	
	
	j boxInputError

wrongGuess:
	li $v0, 4
	la $a0, wrongResponse
	syscall
	
	j guessLoop
	
correctGuess:
	add $s7, $s7, -1
	beqz $s7, winCondition
	li $v0, 4
	la $a0, rightResponse
	syscall
	
	j guessLoop
	
		
boxInputError:
	li $v0, 4
	la $a0, boxErrorResponse
	syscall
	
	j guessLoop		
	
winCondition:
	li $v0, 31
	lb $a0, pitch1
	lb $a1, duration
	lb $a2, instrument
	lb $a3, volume
	syscall

	li $v0, 4
	la $a0, winningResponse
	syscall
	
	li $v0, 4
	la $a0, againPrompt
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 1, newGame
	
	li $v0, 10
	syscall
	
openFile1: 
	li $v0, 13
	la $a0, file1
	li $a1, 0
	li $a2, 0
	syscall			#open file 1
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile2: 
	li $v0, 13
	la $a0, file2
	li $a1, 0
	li $a2, 0
	syscall			#open file 2
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile3: 
	li $v0, 13
	la $a0, file3
	li $a1, 0
	li $a2, 0
	syscall			#open file 3
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile4: 
	li $v0, 13
	la $a0, file4
	li $a1, 0
	li $a2, 0
	syscall			#open file 4
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile5: 
	li $v0, 13
	la $a0, file5
	li $a1, 0
	li $a2, 0
	syscall			#open file 5
	move $s6, $v0		#store file descriptor

openFile6: 
	li $v0, 13
	la $a0, file6
	li $a1, 0
	li $a2, 0
	syscall			#open file 6
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile7: 
	li $v0, 13
	la $a0, file7
	li $a1, 0
	li $a2, 0
	syscall			#open file 7
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile8: 
	li $v0, 13
	la $a0, file8
	li $a1, 0
	li $a2, 0
	syscall			#open file 8
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile9: 
	li $v0, 13
	la $a0, file9
	li $a1, 0
	li $a2, 0
	syscall			#open file 9
	move $s6, $v0		#store file descriptor
	
	j processFile
	
openFile10: 
	li $v0, 13
	la $a0, file10
	li $a1, 0
	li $a2, 0
	syscall			#open file 10
	move $s6, $v0		#store file descriptor
	
	j processFile

setLoop:
	lb $t2, ($t0)
	sb $t2, ($t1)
	sb $t8, ($t0)
	
	lb $t2, 1($t0)
	sb $t2, 1($t1)
	sb $s1, 1($t0)
	
	lb $t2, 2($t0)
	sb $t2, 2($t1)
	sb $t8, 2($t0)

	jr $ra


checkLoop:
	#$t1 has guess address already
	li $t6, 0x30 #Store string "0" in a temp variable

	lb $t7, ($t1)
	lb $t8, 1($t1)

	beq $t8, 0x0A, oneDigit

	lb $t9, 2($t1)
	
	beq $t9, 0x0A, twoDigit

	j finishCheck

oneDigit:
	sb $t6, ($t1)
	sb $t6, 1($t1)
	sb $t7, 2($t1)
	j finishCheck
	
twoDigit:
	sb $t6, ($t1)
	sb $t7, 1($t1)
	sb $t8, 2($t1) 

finishCheck:
	lb $t2, ($t0)
	lb $t3, ($t1)
	
	bne $t2, $t3, wrongGuess
	
	lb $t2, 1($t0)
	lb $t3, 1($t1)
	
	bne $t2, $t3, wrongGuess
	
	lb $t2, 2($t0)
	lb $t3, 2($t1)
	
	bne $t2, $t3, wrongGuess
	#lb $t2, ($t1)
	#sb $t2, ($t0)
	
	jr $ra
	
changeLoop:
	lb $t2, ($t1)
	sb $t2, ($t0)
	
	lb $t2, 1($t1)
	sb $t2, 1($t0)
	
	lb $t2, 2($t1)
	sb $t2, 2($t0)
	
	jr $ra



setVariables:
	la $t9, alphabet
	lb $t8, under
	move $s4, $ra #Stores proper return address 

	#Set A
	lb $s1, 0($t9)
	
	la $t0, p03 
	la $t1, aA
	
	jal setLoop
	
	#Set B
	lb $s1, 1($t9)
	
	la $t0, p04 
	la $t1, aB
	
	jal setLoop
	
	#Set C
	lb $s1, 2($t9)
	
	la $t0, p05
	la $t1, aC
	
	jal setLoop
	
	#Set D
	lb $s1, 3($t9)
	
	la $t0, p07 
	la $t1, aD
	
	jal setLoop
	
	#Set E
	lb $s1, 4($t9)
	
	la $t0, p10 
	la $t1, aE
	
	jal setLoop
	
	#Set F
	lb $s1, 5($t9)
	
	la $t0, p11 
	la $t1, aF
	
	jal setLoop

	#Set G
	lb $s1, 6($t9)
	
	la $t0, p14 
	la $t1, aG
	
	jal setLoop
	
	#Set H
	lb $s1, 7($t9)
	
	la $t0, p16 
	la $t1, aH
	
	jal setLoop
	
	#Set I
	lb $s1, 8($t9)
	
	la $t0, p18 
	la $t1, aI
	
	jal setLoop
	
	#Set J
	lb $s1, 9($t9)
	
	la $t0, p19 
	la $t1, aJ
	
	jal setLoop
	
	#Set K
	lb $s1, 10($t9)
	
	la $t0, p21 
	la $t1, aK
	
	jal setLoop
	
	#Set L
	lb $s1, 11($t9)
	
	la $t0, p27 
	la $t1, aL
	
	jal setLoop
	
	bne $s0, 1, setM
	move $ra, $s4
	jr $ra

setM:	
	#Set M
	lb $s1, 12($t9)
	
	la $t0, p28
	la $t1, aM
	
	jal setLoop
	
	bne $s0, 2, setN
	move $ra, $s4
	jr $ra

setN:	
	#Set N
	lb $s1, 13($t9)
	
	la $t0, p13 
	la $t1, aN
	
	jal setLoop
	
	bne $s0, 3, setO
	move $ra, $s4
	jr $ra

setO:
	#Set O
	lb $s1, 14($t9)
	
	la $t0, p12 
	la $t1, aO
	
	jal setLoop
	
	bne $s0, 4, setP
	move $ra, $s4
	jr $ra
	
setP:	
	#Set P
	lb $s1, 15($t9)
	
	la $t0, p02 
	la $t1, aP
	
	jal setLoop
	move $ra, $s4
	jr $ra
	
	

checkA:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gA
	li $a1, 4
	syscall

	la $t0, aA
	la $t1, gA
	
	jal checkLoop
	
	la $t0, p03
	la $t1, gA
	
	jal changeLoop
	
	j correctGuess
	
checkB:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gB
	li $a1, 4
	syscall

	la $t0, aB
	la $t1, gB
	
	jal checkLoop
	
	la $t0, p04
	la $t1, gB
	
	jal changeLoop
	
	j correctGuess
	
checkC:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gC
	li $a1, 4
	syscall

	la $t0, aC
	la $t1, gC
	
	jal checkLoop
	
	la $t0, p05
	la $t1, gC
	
	jal changeLoop
	
	j correctGuess
	
checkD:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gD
	li $a1, 4
	syscall

	la $t0, aD
	la $t1, gD
	
	jal checkLoop
	
	la $t0, p07
	la $t1, gD
	
	jal changeLoop
	
	j correctGuess
	
checkE:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gE
	li $a1, 4
	syscall

	la $t0, aE
	la $t1, gE
	
	jal checkLoop
	
	la $t0, p10
	la $t1, gE
	
	jal changeLoop
	
	j correctGuess
	
checkF:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gF
	li $a1, 4
	syscall

	la $t0, aF
	la $t1, gF
	
	jal checkLoop
	
	la $t0, p11
	la $t1, gF
	
	jal changeLoop
	
	j correctGuess
	
checkG:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gG
	li $a1, 4
	syscall

	la $t0, aG
	la $t1, gG
	
	jal checkLoop
	
	la $t0, p14
	la $t1, gG
	
	jal changeLoop
	
	j correctGuess
	
checkH:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gH
	li $a1, 4
	syscall

	la $t0, aH
	la $t1, gH
	
	jal checkLoop
	
	la $t0, p16
	la $t1, gH
	
	jal changeLoop
	
	j correctGuess
	
checkI:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gI
	li $a1, 4
	syscall

	la $t0, aI
	la $t1, gI
	
	jal checkLoop
	
	la $t0, p18
	la $t1, gI
	
	jal changeLoop
	
	j correctGuess
	
checkJ:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gJ
	li $a1, 4
	syscall

	la $t0, aJ
	la $t1, gJ
	
	jal checkLoop
	
	la $t0, p19
	la $t1, gJ
	
	jal changeLoop
	
	j correctGuess
	
checkK:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gK
	li $a1, 4
	syscall

	la $t0, aK
	la $t1, gK
	
	jal checkLoop
	
	la $t0, p21
	la $t1, gK
	
	jal changeLoop
	
	lb $t2, 2($t1)
	sb $t2, 2($t0)
	
	j correctGuess
	
checkL:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gL
	li $a1, 4
	syscall

	la $t0, aL
	la $t1, gL
	
	jal checkLoop
	
	la $t0, p27
	la $t1, gL
	
	jal changeLoop
	
	j correctGuess
	
checkM:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gM
	li $a1, 4
	syscall

	la $t0, aM
	la $t1, gM
	
	jal checkLoop
	
	la $t0, p28
	la $t1, gM
	
	jal changeLoop
	
	j correctGuess
	
checkN:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gN
	li $a1, 4
	syscall

	la $t0, aN
	la $t1, gN
	
	jal checkLoop
	
	la $t0, p13
	la $t1, gN
	
	jal changeLoop
	
	j correctGuess
	
checkO:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gO
	li $a1, 4
	syscall

	la $t0, aO
	la $t1, gO
	
	jal checkLoop
	
	la $t0, p12
	la $t1, gO
	
	jal changeLoop
	
	j correctGuess
	
checkP:
	li $v0, 4
	la $a0, guessPrompt
	syscall
	
	li $v0, 8
	la $a0, gP
	li $a1, 4
	syscall

	la $t0, aP
	la $t1, gP
	
	jal checkLoop
	
	la $t0, p02
	la $t1, gP
	
	jal changeLoop
	
	j correctGuess
	
print:
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	li $v0, 4
	la $a0, space12
	syscall
	
	#cell 1
	li $v0, 4
	la $a0, p01
	syscall
	
	#end line 1
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	#spacing
	li $v0, 4
	la $a0, space10
	syscall
	
	#cell 2
	li $v0, 4
	la $a0, p02
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 3
	li $v0, 4
	la $a0, p03
	syscall
	
	#end line 2
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	li $v0, 4
	la $a0, space8
	syscall
	
	#cell 4
	li $v0, 4
	la $a0, p04
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 5
	li $v0, 4
	la $a0, p05
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 6
	li $v0, 4
	la $a0, p06
	syscall
	
	#end line 3
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	li $v0, 4
	la $a0, space6
	syscall
	
	#cell 7
	li $v0, 4
	la $a0, p07
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 8
	li $v0, 4
	la $a0, p08
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 9
	li $v0, 4
	la $a0, p09
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 10
	li $v0, 4
	la $a0, p10
	syscall
	
	#end line 4
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	li $v0, 4
	la $a0, space4
	syscall
	
	#cell 11
	li $v0, 4
	la $a0, p11
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 12
	li $v0, 4
	la $a0, p12
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 13
	li $v0, 4
	la $a0, p13
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 14
	li $v0, 4
	la $a0, p14
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 15
	li $v0, 4
	la $a0, p15
	syscall
	
	#end line 5
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	li $v0, 4
	la $a0, space2
	syscall
	
	#cell 16
	li $v0, 4
	la $a0, p16
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 17
	li $v0, 4
	la $a0, p17
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 18
	li $v0, 4
	la $a0, p18
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 19
	li $v0, 4
	la $a0, p19
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 20
	li $v0, 4
	la $a0, p20
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 21
	li $v0, 4
	la $a0, p21
	syscall
	
	#end line 6
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	
	#cell 22
	li $v0, 4
	la $a0, p22
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 23
	li $v0, 4
	la $a0, p23
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 24
	li $v0, 4
	la $a0, p24
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 25
	li $v0, 4
	la $a0, p25
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 26
	li $v0, 4
	la $a0, p26
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 27
	li $v0, 4
	la $a0, p27
	syscall
	
	#spacing
	li $v0, 4
	la $a0, space1
	syscall
	
	#cell 28
	li $v0, 4
	la $a0, p28
	syscall
	
	#end line 7
	#------------------------------------------------------------------
	
	#spacing
	li $v0, 4
	la $a0, nextline
	syscall
	
	jr $ra
	
