# Name: Byungwoo Kim
# Student ID: 260621422

# Problem 3
# Numerical Integration with the Floating Point Coprocessor
###########################################################
.data
N: .word 100
a: .float 0
b: .float 1
f: .word ident
error: .asciiz "error: must have low < hi\n"
result: .asciiz "Numerial Integration of the function using midpoint method: "

.text 
###########################################################
main:
	# set argument registers appropriately
	lwc1 $f12, a			# loading the floating point a into $f12
	lwc1 $f13, b			# loading floating point b into $f13
	lw $a1, N			# loading the value of N into $a1
	lw $a0, f			# load the label of the function to $a0
	
	# call integrate on test function 
	jal integrate
	# print result and exit with status 0
	li $v0, 4
	la $a0, result
	syscall			# print result message
	
	li $v0, 2
	mov.s $f12, $f0		# copy the result that is held in $f0 to $f12 to print
	syscall
	
	li $v0, 17
	li $a0, 0
	syscall			# exit with status 0
	
	

###########################################################
# float integrate(float (*func)(float x), float low, float hi)
# integrates func over [low, hi]
# $f12 gets low, $f13 gets hi, $a0 gets address (label) of func
# $f0 gets return value
integrate: 
	addi $sp, $sp, -4		# save space on stack
	sw $ra, 0($sp)			# store current return address
	jal check			# check that low < hi
	lw $ra, 0($sp)			# recall the original return address to the main procedure
	addi $sp, $sp, 4		# restore stack
	
	# initialize $f4 to hold N
	# since N is declared as a word, will need to convert 
	mtc1 $a1, $f4
	cvt.s.w $f4, $f4		# converting from w (word) to s (single precision) into $f4
	
	sub.s $f5, $f13, $f12		# $f5 = (b - a)
	div.s $f5, $f5, $f4		# $f5 = (b - a) / N	this will be the width of x, delta(x)
	
	addi $a2, $0, 1			# set $a2 to 1; $a2 will be i
	sub.s $f1, $f1, $f1		# set $f1 to 0, this will hold the result
	loop:				# below is the summation of the midpoints
		sub.s $f6, $f6, $f6	# clear $f6 for use
		mtc1 $a2, $f6
		cvt.s.w $f6, $f6	# convert the i to floating point
		mul.s $f6, $f6, $f5	# $f6 = i * delta(x)
		add.s $f6, $f12, $f6	# $f6 = a + i * delta(x); $f6 is acting as the xi* up to this point
		
		addi $sp, $sp, -8	# save space on stack
		swc1 $f12, 4($sp)	# store the $f12, value for a, so that $f12 can be used for ident
		sw $ra, 0($sp)		# store the current $ra
		
		mov.s $f12, $f6		# copy the $f6, xi*, to $f12 to pass as an argument
		jalr $a0		# call the ident procedure
					# $f0 holds the return value of the function
		mul.s $f6, $f0, $f5	# overwrite $f6 as f(xi*) * delta(x)
		add.s $f1, $f1, $f6	# add the value to the summation
		
		lw $ra, 0($sp)
		lwc1 $f12, 4($sp)
		addi $sp, $sp, 8	# restore stack
		
		addi $a2, $a2, 1	# increment $a2 every loop
		bne $a2, $a1, loop	# loop as long as $a2 does not equal to $a1,
					# which holds the integer value of N
	
	mov.s $f0, $f1			# copy the result to $f0 to return
	
	jr $ra


###########################################################
# void check(float low, float hi)
# checks that low < hi
# $f12 gets low, $f13 gets hi
# # prints error message and exits with status 1 on fail
check:
	c.lt.s $f12, $f13	# the Coprocessor flag 0 will be set to true if $f12 < $f13, in other words if a < b (which we want)
	bc1f exitErr		# branch to exitErr if the Coprocessor flag 0 is false, in other words if a >= b
	jr $ra			# here, a and b passed the check, so jump back to where left off

exitErr:
	li $v0, 4
	la $a0, error
	syscall			# print error message
	
	li $v0, 17
	li $a0, 1
	syscall			# exit with status 1 on fail

###########################################################
# float ident(float x) { return x; }
# function to test your integrator
# $f12 gets x, $f0 gets return value
ident:
	mov.s $f0, $f12
	jr $ra
