# Author: Chance Zibolski
# Description: computes fibonacci recursively, both with memoization, and
# without.

.data
intro:      .ascii  "\nChance Zibolski
            .ascii  "\nThis program computes fibonacci recursively."
            .asciiz "\nWith memoization, and without.\n"


prompt:	.asciiz	"\nEnter an integer in the range [1..25]:"
error_msg:    .asciiz "\nThat number was out of range, try again."

# memoization table
memo:   .word 0
        .word 1
        .space 100


.text

# The main run loop. Everything happens here.
# Pseudocode:
#   void main():
#       print intro
#       n = getN()
#       print "purely recursive"
#       testFib(&fib, n)
#       print "with memoization"
#       testFib(&fibM, n)
#       exit()

main:
    addiu $sp, $sp, -20	# push stack frame

    li $v0, 4           # print intro
    la $a0, intro
    syscall

    jal getN
    move $a0, $v0
    sw $v0, 20($sp) # store n

    jal fib         # call fib(n)

    move $a0, $v0   # copy result to first arg
    li $v0, 1       # print result
    syscall

    li $v0, 11
    li $a0, '\n'
    syscall

    lw $a0, 20($sp) # restore n
    jal fibM        # call fibM(n)

    move $a0, $v0   # copy result to first arg
    li $v0, 1       # print result
    syscall

	addiu $sp, $sp, 20  # pop stack frame
	li    $v0, 10		# system exit
	syscall


# getN(): Get and validate `n` is between 0 and 25
# int getN():
#   print prompt
#   n = readInt()
#   while (n > 25 and n < 0):
#     print error_msg
#     n = get_input()
# Register Mappings:
# $t0: n

getN:
    # print the prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # get integer input
    li $v0, 5
    syscall

    # if value is less than 1, error
    blt $v0, 1, input_error

    # if value is greater than 25, error
    bgt $v0, 25, input_error

    # valid value, return it.
    jr $ra

input_error:
    li $v0, 4
    la $a0, error_msg
    syscall

    j getN


# fib(n): Calculate and return the nth Fibonacci number
#         using a recursive algorithm
# int fib(int n):
#   if n < 2:
#       return n
#   return fib(n-1) + fib(n-2)

fib:
    addiu $sp, $sp, -24
    sw $ra, 16($sp)

    move $v0, $a0
    blt $a0, 2, fib_end

    # fib (n-1)
    sw $a0, 20($sp)     # save n since we're making a call
    subi $a0, $a0, 1    # fib(n-1)
    jal fib
    sw $v0, 24($sp)    # save fib(n-1)

    # fib(n-2)
    lw $a0, 20($sp)     # get n real quick
    subi $a0, $a0, 2    # fib(n-2)
    jal fib

    lw $a0, 24($sp)     # get fib(n-1) back

    add $v0, $a0, $v0   # return = fib(n-1) + fib(n-2)

fib_end:
    lw  $ra, 16($sp)
    addiu, $sp, $sp, 24
    jr $ra




# fibM(n): Calculate and return the nth Fibonacci number using a recursive
#          algorithm and memoization
# memo = []
# int fib(int n):
#   if memo[n]:
#       return memo[n]
#   if n < 2:
#       memo[n] = n
#   else:
#       memo[n] = fib(n-1) + fib(n-2)
#   return memo[n]

fibM:
    addiu $sp, $sp, -32
    sw $ra, 16($sp)

    mul $t0, $a0, 4     # i = n*4
    lw $v0, memo($t0)   # return = memo[i]
    bnez $v0, fibM_end  # if memo[i]

    bge $a0, 2, fibM_else  # if n < 2
    sw $a0, memo($t0)   # memo[n] = n
    move $v0, $a0       # return memo[n]
    j fibM_end

fibM_else:
    sw $a0, 20($sp)     # save n since we're making a call
    sw $t0, 24($sp)     # save the value of i
    subi $a0, $a0, 1    # tmp = n-1
    jal fibM            # fib(tmp)
    sw $v0, 28($sp)     # save fib(n-1)

    # fib(n-2)
    lw $a0, 20($sp)     # get n real quick
    subi $a0, $a0, 2    # tmp = n-2
    jal fibM            # fib(tmp)

    lw $t0, 24($sp)     # restore i
    lw $a0, 28($sp)     # restore fib(n-1)

    add $v0, $a0, $v0   # return = fib(n-1) + fib(n-2)
    sw $v0, memo($t0)   # table[i] = return

fibM_end:
    lw $ra, 16($sp)
    addiu $sp, $sp, 32
    jr $ra
