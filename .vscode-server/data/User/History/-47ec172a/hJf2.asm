section .data
    prompt db "Enter a single digit (0-9): ", 0 ; Prompt to ask the user for input
    prompt_len equ $ - prompt ; Calculate the length of the prompt string
    newline db 10 ; Newline character for printing
    invalid_input_msg db "Invalid input! Please enter a digit (0-9).", 0 ; Error message for invalid input
    invalid_input_len equ $ - invalid_input_msg ; Calculate the length of the invalid input message

section .bss
    array resb 5 ; Reserve 5 bytes for the array where we will store digits
    input resb 2 ; Reserve 2 bytes for the input buffer (character + newline)

section .text
    global _start

_start:
    ; Initialize array index (r12 will serve as a counter to store digits in the array)
    xor r12, r12 ; Clear r12 register to use it as an index (0 to 4)

input_loop:
    ; Print prompt to enter a digit (0-9)
    mov rax, 1 ; sys_write system call number (1 = write)
    mov rdi, 1 ; File descriptor for stdout (1 = standard output)
    mov rsi, prompt ; Address of the prompt string
    mov rdx, prompt_len ; Length of the prompt string
    syscall ; Perform the syscall to print the prompt

    ; Read character from user input
    mov rax, 0 ; sys_read system call number (0 = read)
    mov rdi, 0 ; File descriptor for stdin (0 = standard input)
    mov rsi, input ; Address of the input buffer
    mov rdx, 2 ; Read 2 bytes (character + newline)
    syscall ; Perform the syscall to read input

    ; Check if the input is a valid digit (0-9)
    mov al, [input] ; Load the input character into al register
    cmp al, '0' ; Compare with ASCII value of '0'
    jl invalid_input ; Jump to invalid_input label if less than '0'
    cmp al, '9' ; Compare with ASCII value of '9'
    jg invalid_input ; Jump to invalid_input label if greater than '9'

    ; Store valid character in array at index r12
    mov [array + r12], al ; Store the input digit in the array at position r12
    inc r12 ; Increment r12 to point to the next index in the array

    ; Check if we need more input (we need exactly 5 digits)
    cmp r12, 5
    jl input_loop ; If r12 is less than 5, continue the loop for more input

    ; Reverse the array in place using two pointers (left and right indices)
    mov r12, 0 ; Left index (r12 = 0)
    mov r13, 4 ; Right index (r13 = 4, as we have 5 elements)

reverse_loop:
    ; Check if left index is greater than or equal to right index (exit loop)
    cmp r12, r13
    jge print_array ; If left index >= right index, exit reversal loop and print array

    ; Step 1: Swap elements at r12 (left index) and r13 (right index)
    mov al, [array + r12] ; Load left element (r12) from the array into the al register
    mov bl, [array + r13] ; Load right element (r13) from the array into the bl register

    ; Step 2: Store the swapped elements
    mov [array + r12], bl ; Store the value from the right index (bl) in the left index (r12)
    mov [array + r13], al ; Store the value from the left index (al) in the right index (r13)

    ; Step 3: Move the indices towards each other (left index increases, right index decreases)
    inc r12 ; Increment the left index (r12) to move towards the center of the array
    dec r13 ; Decrement the right index (r13) to move towards the center of the array

    ; Step 4: Repeat the loop until left index is greater than or equal to right index
    jmp reverse_loop ; Continue the loop to reverse the next pair of elements

    ; Challenge with memory handling during reversal:
    ; - I need to be extra careful when accessing array elements via their memory addresses.
    ; - Directly referencing memory with indices could easily lead to errors, especially when accessing out-of-bounds memory.
    ; For example, if the indices for the left and right elements are not managed properly, I could accidentally overwrite the memory
    ; or cause undefined behavior by accessing the wrong parts of memory.
    ; - The assembly doesn't provide automatic bounds checking, so I have to manage the array size manually to avoid issues.
    ; - Swapping the elements requires careful memory management, making sure I store values in the correct places without
    ; unintentionally corrupting any memory.

print_array:
    ; Print the reversed array
    mov r12, 0 ; Reset the counter to start printing from the first index of the array

print_loop:
    ; Get character from array at index r12
    mov al, [array + r12]
    mov [input], al ; Store it in the input buffer

    ; Print character
    mov rax, 1 ; sys_write system call number (1 = write)
    mov rdi, 1 ; File descriptor for stdout (1 = standard output)
    mov rsi, input ; Address of the input buffer
    mov rdx, 1 ; Print 1 byte (1 character)
    syscall ; Perform the syscall to print the character

    ; Print newline after each character
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Increment index and check if all characters have been printed
    inc r12
    cmp r12, 5
    jl print_loop ; Continue printing if we haven't reached the end of the array

exit:
    mov rax, 60 ; sys_exit system call number (60 = exit)
    xor rdi, rdi ; Exit status code 0 (successful)
    syscall ; Perform the syscall to exit

invalid_input:
    ; Print invalid input message
    mov rax, 1 ; sys_write system call number (1 = write)
    mov rdi, 1 ; File descriptor for stdout (1 = standard output)
    mov rsi, invalid_input_msg
    mov rdx, invalid_input_len
    syscall

    ; Restart the input loop after invalid input
    jmp input_loop