# Author:       Chance Zibolski
# Date:	        02-24-2013
# Description:  Programming Assignment 3. Procedure calls!

.data
# string constants

# setup
intro:   .asciiz "Chance Zibolski. Programming assignment 3.\n"

prompt_text: .asciiz "\nInput a string to analyze:"

# globals
freq:    .space 104  # 26 integer array
text:    .space 1024 # 1024 character array

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
        jal analyze
        jal results

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
# i: $s0, freq: $s1, n: $v0

analyze:
        # set up stack frame
        addiu $sp, $sp, -24 # new stack frame
        sw $ra, 20($sp)     # save return address

        # initialize i to 'a'
        li $s0, 97
        # store pointer to freq[0]
        la $s1, freq

# Loop through each letter
analyze_loop:
        move $a0, $s0    # count(i)
        jal count        # n = count(i)
        sw $v0, 0($s1)   # freq[i] = n
        addi $s0, $s0, 1 # i++
        addi $s1, $s1, 4 # increment pointer to freq
        ble $s0, 122, analyze_loop # loop until we've gone through the 26 letters


returnn:
        lw $ra, 20($sp)     # get our return address
        addiu $sp, $sp, 24  # pop stack frame
        jr $ra              # Return to caller

# count(letter):
#   i = 0
#   counter = 0
#   temp = upper(letter)
#   while(1):
#       if ( text[i] == NULL):
#           break
#       if ( text[i] == letter ):
#           counter += 1
#       elif ( text[i] == letter ):
#           counter += 1
#       i += 1
#   return counter
# $a0: letter
# $t0: text
# $t1: i
# $t2: counter
# $t3: text[i]
# $t4: temp
count:
        la $t0, text # base address
        li $t1, 0  # i = 0
        li $t2, 0  # counter = 0

count_loop:
        lb $t3, 0($t0)  # text[i]
        beqz $t3, count_done  # if text[i] == NULL: break

        beq $t3, $a0, letter_match  # if (text[i] == letter )
        addi $t4, $a0, -32          # temp = upper(letter)
        beq $t3, $t4, letter_match  # elif (text[i] == temp )
        j count_loop_increment

letter_match:
        addi $t2, $t2, 1    # counter += 1

count_loop_increment:
        addi $t0, $t0, 1    # i += 1 (because we're incrementing the address)
        j count_loop

count_done:
        move $v0, $t2 # return counter

        jr $ra

# results()
results:

        la $t0, freq
        li $t1, 'A'
results_loop:
        # Print the letter
        li $v0, 11
        move $a0, $t1
        syscall

        # Print the ": "
        la $v0, 11
        li $a0, ':'
        syscall

        # Retrieve and print the letter's count
        lw $a0, 0($t0)
        li $v0, 1
        syscall

        # Print the newline
        li $v0, 11
        li $a0, '\n'
        syscall

        # Increment the address of freq we're working on
        # and increment our counter
        addi $t0, $t0, 4
        addi $t1, $t1, 1

        ble $t1, 'Z', results_loop

        jr $ra

