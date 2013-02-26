# Author:       Chance Zibolski
# Date:	        02-24-2013
# Description:  Programming Assignment 3. Procedure calls!

.data
# string constants

# setup
intro:   .asciiz "Chance Zibolski. Programming assignment 3.\n"

prompt_text: .asciiz "\nInput a string to analyze: "

# globals
text:    .space 1024
freq:    .word  26

.text

# Procedure: main
# Pseudocode:
# setup()
# analyze()
# results()
# exit()

main:
    # Run setup procedure
    jal setup

    # Later alligator (exit)
    li  $v0, 10
    syscall

# Procedure: setup
# Pseudocode:
#   print intro
#   print prompt
#   text = read_string()

setup:
    # print string
    li $v0, 4

    # print intro
    la $a0, intro
    syscall

    # print prompt
    la $a0, prompt_text
    syscall

    # Get user input
    li $v0, 8
    la $a0, text
    li $a1, 1024 # Max num of chars to read
    syscall

    # Return to caller
    jr $ra

# Procedure: analyze
# Pseudocode:
# for (i = 'a'; i < 'z'; i++) {
#   n = count(i)
#   freq[i] = n;
# }
# Mappings:
# i: $s0, n: $v0
analyze:
    # start with 0
    li $s0, 0
    # Loop through each letter
    analyze_loop:
        li, $a0, $s0 # load the current letter into the first arg of count
        jal count    # call count
        # get return value n
        # store n into freq[i]
        addi $s0, $s0, 1 # increment the letter we are working on
        blt $s0, 26, analyze_loop # loop until we've gone through the 26 letters

    # Return to caller
    jr $ra


count:

    jr $ra

