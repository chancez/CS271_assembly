# Author:       Chance Zibolski
# Date:	        02-11-2013
# Description:  Programming Assignment 1. Uses loops!

.data

# string constants
intro:   .ascii "Chance Zibolski. Programming assignment 2.\n"
         .asciiz "Fibonacci Program!\n"

prompt:  .asciiz "\nEnter your name: "
hello:   .asciiz "\nHello, "
goodbye: .asciiz "\nGoodbye, "

num_prompt: .ascii  "\nHow many Fibonacci numbers should I display? "
            .asciiz "\nEnter an integer between 1 and 47 (inclusive): "
num_err:    .asciiz "\nThat number was out of range, try again "

spaces:     .asciiz "    "
nl:         .asciiz "\n"

# results stored into data memory
name:     .space   64

.text
# Section 1: Introduction
# Pseudocode:
#   print intro
#   print prompt
#   name = readString()
#   print name

    # print intro
    li $v0, 4
    la $a0, intro
    syscall

    # print prompt
    la $a0, prompt
    syscall

    # take user input
    li $v0, 8    # read text
    la $a0, name # storage location
    li $a1, 64   # max is 64 bytes
    syscall

    # print hello
    li $v0, 4
    la $a0, hello
    syscall

    # print users name
    la $a0, name
    syscall


# Section 2: Get and validate "n"
# Prompt a user to enter a number n, between 1 and 47
# print num_prompt
# n = readInt()
# while (n > 47 and n < 0):
#   print error_msg
#   n = get_input()
# Register Mappings:
# $t0: n

loop:
    # print the prompt
    li $v0, 4
    la $a0, num_prompt
    syscall

    # get integer input
    li $v0, 5
    syscall

    # if value is less than 0, ask for input again
    bltz $v0, loop

    # if value is greater than 47, ask for input again
    bgt $v0, 47, loop

    # copy n into $t0 (done at the end of the loop since we discard the result
    # if its incorrect anyways
    move $t0, $v0

# Section 3: Calculate & Print the first N Fibonacci numbers.
# Calculate and print each of the Fibonacci numbers up to and including N
# prev1 = 0
# prev2 = 1
# while (loop_counter < n):
#   temp = prev1
#   prev1 = prev2
#   prev2 = prev2 + temp
#   print prev2
# Register Mappings:
# $t0: n
# $t1: prev1
# $t2: prev2
# $t3: temp
# $t4: loop_counter

    # seed values:
    li $t1, 0
    li $t2, 1

    #always print 0, our input always requires at least 1.
    li $a0, 0
    li $v0, 1
    syscall

    # initialize our loop counter to 1 (since we printed 0 already)
    li $t4, 1
    # skip to the printing spaces part of the fib_loop.
    li $v0, 4       # used for the printing_spaces part
    j print_spaces

fib_loop:
    # if its our first values skip to printing them and incrementing the
    # counter
    blt $t4, 2, printer
    # if it isnt our seed values, we need to do some math!
math:
    # store prev1 into temp
    move $t3, $t1
    # move prev2 into prev1
    move $t1, $t2
    # compute sum and store into prev2
    add $t2, $t3, $t2

printer:
    # print prev2 (sum of the previous 2 values)
    li $v0, 1
    move $a0, $t2
    syscall

    # add one to loop counter
    addi $t4, $t4, 1

    # used for print_newline and print_spaces
    li $v0, 4
    # should we print 5 more spaces or a newline?
    # if (loop_counter % 5) == 0
    rem $t3, $t4, 5
    beqz $t3, print_newline
    # else
    j print_spaces

print_newline:
    la $a0, nl
    j then
print_spaces:
    la $a0, spaces
then:
    syscall # print the previous part
    bgt $t0, $t4, fib_loop

# Section 4: Print a concluding message and exit
# Pseudocode:
#   print goodbye + name
#   exit()
# syscall: 10
exit:
    # print goodbye
    li $v0, 4
    la $a0, goodbye
    syscall

    # print users name
    la $a0, name
    syscall

    # exit
    li  $v0, 10
    syscall
