#StudentID: 260621422
#Name: Byungwoo Kim

.data
originalList:	.asciiz	"\n\nOriginal linked list\n"
askUser:	.asciiz	"\nInput a single character ('*' to finish): "
reversedList:	.asciiz	"\n\nReversed linked list\n"

.text
main:
#build a linked list
#print "Original linked list\n"
#print the original linked list
	jal build			# jal to build function to build a new singly linked list
					# ($v1 holds the address of the first node after the function)
	
	la $a0, originalList		# printing the "Original linked list\n"
	li $v0, 4
	syscall
	
	move $a0, $v1			# copy the address of the first node from $v1 to $a0 to pass it to the print function
	move $a1, $v1			# copy the address of the first node to $a1 as well to use later (for reverse)
	jal print
	
#reverse the linked list
#On a new line, print "reversed linked list\n"
#print the reversed linked list
#terminate program
	
	jal reverse			# reverse the linked list that starts at $a1
	
	la $a0, reversedList		# print the "Reversed linked list\n"
	li $v0, 4
	syscall
	
	move $a0, $v1			# copy the address of the first node of the reversed list to pass to print function
	jal print			# print
	
	li $v0, 10			# tell the program to terminate
	syscall




build:
#continually ask for user input UNTIL user inputs "*"
#FOR EACH user inputted character inG, create a new node that hold's inG AND an address for the next node
#at the end of build, return the address of the first node to $v1
	la $a0, askUser			# ask for user input
	li $v0, 4
	syscall
	
	li $v0, 12			# take a single character input into $v0
	syscall
	
	addi $t0, $v0, 0		# now $t0 holds the input value as well (so that we can use $v0)
	
	li $v0, 9
	li $a0, 8			# allocate 8 bytes of space
	syscall				# $v0 gets the address of the block
	
	sw $t0, 0($v0)			# store the input to the first
	beq $t0, 42, finishBuild	# if the input was '*', finish building the linked list
	
	move $a1, $v0			# save the address in $v0 in $a1
	move $v1, $v0			# save the address of the first node to $v1 to return at the end
	j continueBuild			# if input is not '*', then continue building the linked list
	
	continueBuild:
		la $a0, askUser		# continually ask for user input
		li $v0, 4
		syscall
		
		li $v0, 12		# take input
		syscall
		
		move $t0, $v0		# move the input to $t0
		
		li $v0, 9
		li $a0, 8		# allocate
		syscall			# $v0 gets the address of the allocated block
		
		sw $t0, 0($v0)		# store the input to the node
		beq $t0, 42, finishBuild	# finish building linked list
		
		sw $v0, 4($a1)		# save the address of current node into the second part of the previous node
		move $a1, $v0		# "overwrite" $a1 with the address of current node (previously was the address of the previous node)
		j continueBuild		# jump back to the loop and continue building the linked list
		
	
	finishBuild:
		sw $0, 4($v0)		# the last node points to NULL, so save $0 as the address of the next node
		jr $ra			# jump back to the main function
	
	


print:
#$a0 takes the address of the first node
#prints the contents of each node in order
	beq $a0, $0, done	# finish printing if the current node is NULL
	move $a2, $a0		# move the address of the current node to $a2, so that we can use $a0
	
	lw $a0, 0($a2)		# load a word from the current address, which is the single character the node holds
	li $v0, 11		# $v0 = 11 in order to print a single character
	syscall			# print the character of the current node
	
	lw $a0, 4($a2)		# $a0 now holds the address of the next node
	j print			# loop back to the print function with $a0 holding the address of the next node
	
	done:
		jr $ra		# jump back to the main function




reverse:
#$a1 takes the address of the first node of a linked list
#reverses all the pointers in the linked list
#$v1 returns the address
	lw $a3, 4($a1)		# save the address of the next node to $a3
	sw $0, 4($a1)		# set the "next node" of the current node to be NULL
	beq $a3, $0, endReverse	# if the address of the next node that was saved in $a3 points to NULL, end reversing
	j continueReverse	# if not, continue reversing
	
	
continueReverse:
	addi $sp, $sp, -8	# space on stack
	sw $ra, 4($sp)		# save return address
	sw $a1, 0($sp)		# save the address of the current node
	
	move $a1, $a3		# get the address of the "next node"
	jal reverse		# jump and link back to reverse funtion, this time with the address of the "next node"
	
	lw $a2, 0($sp)		# restore the address of the "previous node"
	lw $ra, 4($sp)		# get return address back
	addi $sp, $sp, 8	# restore stack
	
	sw $a2, 4($a1)		# the "next node" of the current node will be the prior "previous node" now
	move $a1, $a2		# look at the "previous node" now
	
	jr $ra			# jump back to wherever left off
	
	
endReverse:
	move $v1, $a1		# save the address of the current node (which will be the start of the reversed node) to return
	jr $ra			# jump back to wherever left off
