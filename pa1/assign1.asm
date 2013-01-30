# Author:       Chance Zibolski
# Date:	        01-28-2013
# Description:  Programming assign1. Does math!

.data

# string constants
intro:   .ascii "Chance Zibolski. Programming assignment 1.\n"
         .asciiz "This program does some math! You will be entering 2 numbers\n"
prompt1: .asciiz "Enter your first number: "
prompt2: .asciiz "Enter your second number: "
goodbye: .asciiz "The program is now going to exit. \n"

# results stored into data memory
sum:        .word   0
difference: .word   0
product:    .word   0
quotient:   .word   0
remainder:  .word   0

.text
# Section 1: Prints name, title and description of this program.
# Pseudocode:
#   print intro
# Register/variable mappings:
#    syscall: 4

    # print intro
    la  $a0, intro
    # syscall
    li  $v0, 4
    syscall

# Section 2: Prompt user for two numbers, and save into two registers
# Pseudocode: 
#   print prompt1
#   val1 = read_int()
#   print prompt2
#   val2 = read_int()
# syscall: 5, val1: $t0, val2: $t1

    # print first prompt
    la  $a0, prompt1
    li  $v0, 4
    syscall

    # get data, store into $t0
    li  $v0, 5 # get_int()
    syscall #result is in $v0
    move $t0, $v0

    #second number input
    # print second prompt
    la  $a0, prompt2
    li  $v0, 4
    syscall

    # get data, store into $t1
    li  $v0, 5 # get_int()
    syscall #result is in $v0
    move $t1, $v0

# Section 3: Computes sum, difference, product
# and quotient & remainder of the two inputs
# Pseudocode:
#   sum = val1 + val2
#   difference = val1 - val2
#   product = val1 * val2
#   quotient = val1 / val2
#   remainder = val1 % val2
# Register/variable mappings:
# variables declared in .data will be where results are saved
# val1: $t0, val2: $t1, temp: $t2

    # compute sum, store in sum
    add  $t2, $t0, $t1
    sw   $t2, sum

    # compute difference, store in difference
    sub  $t2, $t0, $t1
    sw   $t2, difference

    # compute product, store in product
    mul  $t2, $t0, $t1
    sw   $t2, difference

# Section 4: Print computed values that are stored in data segment
# Pseudocode:
#   print sum
#   print difference
#   print product
#   print quotient
#   print remainder

    # load print_int syscall into syscall register
    li  $v0, 1

    # print sum
    #sw  $t0, sum
    #li  $t2, '+'
    #sw  $t2, sum + 4
    #sw  $t1, sum + 8
    lw  $a0, sum
    syscall

    # print difference
    #lw  $a0, difference
    #syscall

    ## print product
    #lw  $a0, product
    #syscall

# Section 5: Print a concluding message and exit
# Pseudocode: 
#   print goodbye
#   exit()
# syscall: 10

    # print goodbye
    la $a0, goodbye
    li $v0, 4
    syscall

    # exit
    li  $v0, 10
    syscall
