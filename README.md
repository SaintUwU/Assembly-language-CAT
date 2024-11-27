ALP CAT 2
QUESTION 1
This program, written in x86 assembly for Linux, prompts the user to input a number, determines whether the number is positive, negative, or zero, and prints the corresponding message. It does the following
Prompt the User: It uses the sys_write system call to display the message "Enter a number:".
Read User Input: Uses the sys_read system call to take a string input from the user.
Parse Input:
Converts the ASCII input into an integer.
Detects if the number is negative based on the presence of a '-' sign.
Classify the Number: Compares the parsed number with zero to classify it as positive, negative, or zero.
Output Result: Outputs "POSITIVE," "NEGATIVE," or "ZERO" based on the classification using the sys_write system call.
Exit: Terminates the program using the sys_exit system call.
Challenges 
Input Validation:

Challenge: The program assumes valid numeric input. If the user enters non-numeric characters, the behavior is undefined and likely incorrect.

Fixed Input Size:

Challenge: The input size is limited to 8 bytes. Larger numbers or longer inputs will either be truncated or cause buffer overflows.

QUESTION 2
This program prompts the user to enter 5 numbers which are then returned back to the user in the reversed order.
This assembly program interacts with the user in the following steps:

Input Collection: Prompts the user to enter five single-digit numbers (0-9) in a loop. The program validates that each input is a valid digit.
Array Management: Stores the five valid digits in an array.
Array Reversal: Reverses the order of the digits in the array in place using two-pointer swapping.
Output: Prints the reversed array, one digit per line.

Challenges and Potential Improvements
1. Input Handling:
Challenge: The program assumes that input always contains exactly one digit followed by a newline. Any deviation (e.g., extra characters) can result in unexpected behavior.

2. Error Recovery:
Challenge: On invalid input, the program re-prompts the user but does not discard invalid input from the buffer.

3. Fixed Array Size:
Challenge: The program is limited to an array size of 5, making it inflexible for other use cases.

QUESTION 3
This assembly program calculates the factorial of a user-provided positive integer. It uses a combination of system calls, arithmetic operations, and subroutines to accomplish the following:

Prompt for Input: Requests a positive integer from the user.
Input Parsing: Converts the ASCII input into an integer.
Factorial Calculation: Computes the factorial of the given number using a loop-based subroutine.
Result Display: Converts the resulting number into its ASCII representation and displays it on the screen.

Potential Issues 
1. Input Validation
Problem: The program does not validate that the input is a positive integer. Non-digit or negative inputs will cause undefined behavior.
2. Factorial Overflow
Problem: Factorials grow rapidly, and the result will overflow 64 bits for values greater than 20.

QUESTION 4
This assembly program simulates a sensor-based control system for a motor and an alarm. It takes a sensor value as input from the user and determines the appropriate actions for the motor and alarm based on predefined thresholds:
Input Validation:
The code doesn't explicitly validate the user input to ensure it's a valid integer within a specific range. This could lead to unexpected behavior if the user enters invalid input.
Error Handling:
The code doesn't handle potential errors like division by zero or out-of-bounds array access. Implementing error handling mechanisms can make the program more robust.

How to run Q1
 nasm -f elf32 question1.asm -o question.o
 ld -m elf_i386 question1.o -o question1
 ./question1

## Question 2
```nasm -f elf64 Question2.asm -o Question2.o
ld Question2.o -o Question2
./Question2
```
## Question 3
```nasm -f elf64 Question3.asm -o Question3.o
ld Question3.o -o Question3
./Question3
```
## Question 4
```nasm -f elf64 Question4.asm -o Question4.o
ld Question4.o -o Question4
./Question4
```
