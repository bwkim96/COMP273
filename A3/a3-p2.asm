# Name: Byungwoo Kim
# Student ID: 260621422

# Problem 2 - Dr. Ackermann or: How I Stopped Worrying and Learned to Love Recursion
###########################################################
.data
error:	.asciiz "error: m, n must be non-negative integers\n"
promptm:.asciiz "Input the value for m (must be a natural number): "
promptn:.asciiz "Input the value for n (must be a natural number): "
result:	.asciiz "\nThe result of the Ackermann function of the input m and n, A(m,n) is: "

.text 
###########################################################
main:
# get input from console using syscalls
	li $v0, 4		# prompt the user for input m
	la $a0, promptm
	syscall
	
	li $v0, 5		# get input m from the user, must be integer
	syscall
	move $a1, $v0		# store the value into $a1
	
	li $v0, 4		# prompt the user for input n
	la $a0, promptn
	syscall
	
	li $v0, 5		# get input n from the user, must be integer
	syscall
	move $a2, $v0		# store the value into $a2
	
# compute A on inputs 
	jal A			# the result will be returned in $v0
	
# print value to console and exit with status 0
	move $v1, $v0		# copy the result into $v1, so that we can use $v0 for syscall
	
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $v1
	syscall			# print the result integer (but really a natural number)
	
	li $v0, 17
	li $a0, 0
	syscall			# exit with status 0

###########################################################
# int A(int m, int n)
# computes Ackermann function
A: 				# $a1 = m, $a2 = n, store the result A(m,n) in $v0 at the end
	addi $sp, $sp, -8	# space on stack for m and the return address
	sw $s0, 4($sp)		# store the $s0, which will be holding the old m value
	sw $ra, 0($sp)		# save the current return address onto stack
	
	jal check		# check to make sure m and n are natural numbers
	
	bgt $a1, $0, mGreater	# go to mGreater procedure if m > 0
	# below if m = 0, because m must be >= 0
	addi $v0, $a2, 1	# n + 1, store the result in $v0 to return
	j end			# jump to end procedure
	
	#jr $ra			# did not use...
	
mGreater:			# here, we know m > 0
	bgt $a2, $0, nGreater	# go to nGreater procedure if n > 0
	# below if m > 0 and n = 0, since n must be >= 0
	addi $a1, $a1, -1	# m = m - 1
	li $a2, 1		# n = 1
	jal A			# call A procedure again, with the new m and n (A(m-1,1))
	j end			# the result will be in $v0, now just jump to the end function
	
nGreater:			# here, we know m > 0 and n > 0
	move $s0, $a1		# copy m to $s0 to store to stack, to keep track of the old m,
				# since it might change in the process
	addi $a2, $a2, -1	# n = n - 1
	jal A			# call A with new m and n, A(m, n-1)
	
	move $a2, $v0		# the result of the above A(m,n-1) will be the new n to be used
	addi $a1, $s0, -1	# m = m - 1, but we have to use the old (original) m here,
				# so use the $s0 which we saved the old m in
	jal A			# A(m-1, A(m,n-1))
				# do not need to jump to exit separately here

end:
	lw $ra, 0($sp)		# restore the original return address
	lw $s0, 4($sp)		# restore the old m
	addi $sp, $sp, 8
	jr $ra
	
###########################################################
# void check(int m, int n)
# checks that n, m are natural numbers
# prints error message and exits with status 1 on fail
check:
	slt $t0, $a1, $0		# $t0 = 1 if $a1, or m, is less than 0
	bne $t0, $0, exitErr		# exit with error if m IS less than 0, since it is not a natural number
	slt $t0, $a2, $0		# same with $a2, or n
	bne $t0, $0, exitErr
	jr $ra				# reaching this means that m and n passed the check, jump back to where left off
	
exitErr:
	lw $ra, 0($sp)		# restore stacks
	lw $a1, 4($sp)
	addi $sp, $sp, 8
	
	li $v0, 4
	la $a0, error
	syscall			# print error message
	
	li $v0, 17
	li $a0, 1
	syscall			# exit with status 1 on fail