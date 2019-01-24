# Program to capitalize the first letter of a string
# Byungwoo Kim, ID 260621422

	.data						# variable declarations follow this line
str: 	.asciiz "Enter the string to capitalize: "
userInput: .space 127				#declare variable to take in user's input string
				
																																															
	.text		# instructions follow this line
											                    
main:				# indicates start of code to test "upper" the procedure
	li $v0, 4		# prompt the user for input
	la $a0, str
	syscall
	
	li $v0, 8		# getting input from user
	la $a0, userInput
	li $a1, 127
	syscall
	
	addi $t0, $0, 0		# setting $t0 as 0, it is going to be the index
	jal upper		# call upper procedure
	
	li $v0, 4		# print the capitalized string
	la $a0, userInput
	syscall
	
	li $v0, 10		# tell the program to terminate
	syscall
	
	
	
	
upper:			# the “upper” procedure
	lb $t1, userInput($t0)	# load byte into $t1 (getting each character from the string)
	beq $t1, 0, exit	# if $t1 == 0, it means that the character is null, thus the string has ended
	
	blt $t1, 'a', nextWord	# the character is not a lowercase letter
	bgt $t1, 'z', nextWord	# the character is not a lowercase letter
	
	addi $t1, $t1, -32	# the character is a lowercase letter, so change its ASCII value to capitalize it
	sb $t1, userInput($t0)	# save the character back into its place
	
	j nextWord		# get the next word
	

nextWord:	# procedure to get the next word
	addi $t0, $t0, 1	# increment index
	lb $t1, userInput($t0)	# get the next character
	beq $t1, 0, exit	# exit if string ends
	bne $t1, ' ', nextWord	# repeat the procedure until the character is a space
	addi $t0, $t0, 1	# increment the index, and now the next character would be the start of a new word
	j upper			# jump back to upper function

exit:		# exit function
	jr $ra			# jump back to $ra, in the main function

									
# End of program
