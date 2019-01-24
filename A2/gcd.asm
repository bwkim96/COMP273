# Program to implement the Dijkstra's GCD algorithm
# Byungwoo Kim, ID 260621422

	.data		# variable declarations follow this line
str1: 	.asciiz "Enter the first integer: "
str2: 	.asciiz "Enter the second integer: " 
				
											
	.text		# instructions follow this line	
	
main:     		# indicates start of code to test lcm the procedure
	li $v0, 4		# prompt the user for input 1
	la $a0, str1
	syscall
	
	li $v0, 5		# get input from the user (first integer)
	syscall
	move $a1, $v0		# store the value into $a1
	
	li $v0, 4		# prompt the user for input 2
	la $a0, str2
	syscall
	
	li $v0, 5		# get second input from the user
	syscall
	move $a2, $v0		#store the value into #a2
	
	jal gcd			# jump and link to gcd
	
	li $v0, 1		# load immediate in order to print the result
	addi $a0, $v1, 0	# copy the result into $a0 to print
	syscall			# print
	
	li $v0, 10		# tell the program to finish.
	syscall	
	
																                    																	                    
			
																	                    																	                    																	                    																	                    														                    																	                    																	                    																	                    
gcd:	     		# the “lcm” procedure
	
	addi $sp, $sp, -12	# space on stack
	sw $ra, 8($sp)		# save return address
	sw $a2, 4($sp)		# save n
	sw $a1, 0($sp)		# save m
	
	beq $a1, $a2, exit	#if (m==n) return m
	
	slt $t0, $a2, $a1	# else if (m > n)
	bne $t0, $0, mgreater	# goto mgreater
	
	slt $t0, $a1, $a2	# else (m < n)
	bne $t0, $0, ngreater	# goto ngreater
	

	
mgreater:
	sub $a1, $a1, $a2	# m = m-n
	jal gcd			# gcd(m-n, n)
	
	lw $a1, 0($sp)		# restore m
	lw $a2, 4($sp)		# restore n
	lw $ra, 8($sp)		# get return address back
	addi $sp, $sp, 12	# restore stack
	
	jr $ra			# return to main
	
	
	
ngreater:
	sub $a2, $a2, $a1	# n = n-m
	jal gcd			# gcd(m, n-m)
	
	lw $a1, 0($sp)		# restore m
	lw $a2, 4($sp)		# restore n
	lw $ra, 8($sp)		# get return address back
	addi $sp, $sp, 12	# restore stack
	
	jr $ra			# return to main
	
	
	
exit:
	add $v1, $a1, $0	# store the $a1 (m) into $v1 to return
	lw $a1, 0($sp)		# restore m
	lw $a2, 4($sp)		# restore n
	lw $ra, 8($sp)		# get return address back
	addi $sp, $sp, 12	# restore stack
	
	jr $ra			# return to main
	
	

									
# End of program
