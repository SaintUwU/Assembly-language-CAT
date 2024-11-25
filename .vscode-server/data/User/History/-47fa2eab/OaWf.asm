section .data
    prompt db "Enter a number: ", 0      ; Message to prompt user
    pos_msg db "POSITIVE", 0            ; Positive message
    neg_msg db "NEGATIVE", 0            ; Negative message
    zero_msg db "ZERO", 0               ; Zero message
    input db 0                          ; Space to store the input character

section .bss
    number resb 8                       ; Reserve space for the input number

section .text
    global _start

_start:
    ; Print the prompt
    mov rax, 1                          ; sys_write
    mov rdi, 1                          ; File descriptor (stdout)
    mov rsi, prompt                     ; Address of the prompt string
    mov rdx, 17                         ; Length of the prompt string
    syscall

    ; Read the input
    mov rax, 0                          ; sys_read
    mov rdi, 0                          ; File descriptor (stdin)
    mov rsi, number                     ; Address to store input
    mov rdx, 8                          ; Max input length
    syscall

    ; Convert ASCII input to integer
    mov rax, 0                          ; Clear rax (for the result)
    mov rcx, number                     ; Load the address of the input
    movzx rdx, byte [rcx]               ; Load the first character

    ; Check if input is negative
    cmp rdx, '-'                        ; Compare the character to '-'
    jne check_zero                      ; If not '-', jump to check_zero
    inc rcx                             ; Skip the '-' sign
    movzx rdx, byte [rcx]               ; Load the next character

check_zero:
    ; Check if input is zero
    cmp rdx, '0'
    je print_zero                       ; If input is '0', jump to print_zero

convert_to_int:
    ; Convert ASCII digits to integer
    sub rdx, '0'                        ; Convert ASCII to integer
    imul rax, 10                        ; Multiply the result by 10
    add rax, rdx                        ; Add the current digit
    inc rcx                             ; Move to the next character
    movzx rdx, byte [rcx]               ; Load the next character
    cmp rdx, 10                         ; Check for end of input (newline)
    jl convert_to_int                   ; Loop until the end of input

    ; Classify the number
classify:
    cmp rax, 0                          ; Compare the number with 0
    jg print_positive                   ; If greater than 0, jump to positive
    jl print_negative                   ; If less than 0, jump to negative

print_zero:
    ; Print "ZERO"
    mov rax, 1                          ; sys_write
    mov rdi, 1                          ; File descriptor (stdout)
    mov rsi, zero_msg                   ; Address of "ZERO"
    mov rdx, 4                          ; Length of "ZERO"
    syscall
    jmp exit                            ; Unconditional jump to exit

print_positive:
    ; Print "POSITIVE"
    mov rax, 1                          ; sys_write
    mov rdi, 1                          ; File descriptor (stdout)
    mov rsi, pos_msg                    ; Address of "POSITIVE"
    mov rdx, 8                          ; Length of "POSITIVE"
    syscall
    jmp exit                            ; Unconditional jump to exit

print_negative:
    ; Print "NEGATIVE"
    mov rax, 1                          ; sys_write
    mov rdi, 1                          ; File descriptor (stdout)
    mov rsi, neg_msg                    ; Address of "NEGATIVE"
    mov rdx, 8                          ; Length of "NEGATIVE"
    syscall
    jmp exit                            ; Unconditional jump to exit

exit:
    ; Exit the program
    mov rax, 60                         ; sys_exit
    xor rdi, rdi                        ; Exit code 0
    syscall
