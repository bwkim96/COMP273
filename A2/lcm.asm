# Program to calculate the least common multiple of two numbers
# Byungwoo Kim, ID 260621422

	.data		# variable declarations follow this line
first: 	.word 10	# the first integer
second: .word 15    	# the second integer                  
														
	.text		# instructions follow this line	
# indicates start of code to test lcm the procedure						                    
main:	lw $a1, first     		# saves the two integers into two argument registers
	lw $a2, second			
	add $t1, $a1, $0		# also save the two integers into two temp registers
	add $t2, $a2, $0		
	jal lcm				#jump and link to lcm procedure
	
	li $v0, 1			#load immediate in order to print the result
	addi $a0, $v1, 0		#copy the result into $a0 to print
	syscall				#print
	
	li $v0, 10			# tell the program to finish.
	syscall				

# the “lcm” procedure
lcm:	slt $t0, $a1, $a2		#set $t0 to 1 if the first integer is less than the second
	bne $t0, $0, addFir		# branch to addFir function if first int is less than second int
	slt $t0, $a2, $a1		#$t0 = 1 if the second int is smaller than first
	bne $t0, $0, addSec		# branch to addSec if second integer is smaller than first
	
	bne $a1, $a2, lcm		# loop back to lcm function if the two numbers are not equal yet
	add $v1, $a1, $0		# if the two numbers are equal, that number is the result. Save that number to $v1 to return
	jr $ra				# jump back to where left off in the main

addFir:	add $a1, $a1, $t1		# add the first integer to itself every time, this would be like (first integer) x n, where n is increased every time
	j lcm				# go back to lcm and repeat
	
addSec:	add $a2, $a2, $t2		# same as addFir, but work on the second number
	j lcm


									
# End of program
