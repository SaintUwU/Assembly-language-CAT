section .data
    prompt db "Enter a number: ", 0      ; Message to prompt user
    pos_msg db "POSITIVE", 0            ; Positive message
    neg_msg db "NEGATIVE", 0            ; Negative message
    zero_msg db "ZERO", 0               ; Zero message

section .bss
    number resb 8                       ; Reserve space for the input number

section .text
    global _start

_start:
    ; Print the prompt
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; File descriptor (stdout)
    mov ecx, prompt                     ; Address of the prompt string
    mov edx, 17                         ; Length of the prompt string
    int 0x80                             ; System call

    ; Read the input
    mov eax, 3                          ; sys_read
    mov ebx, 0                          ; File descriptor (stdin)
    mov ecx, number                     ; Address to store input
    mov edx, 8                          ; Max input length
    int 0x80                             ; System call

    ; Convert ASCII input to integer
    xor eax, eax                        ; Clear eax (for the result)
    xor ebx, ebx                        ; Clear ebx (for the sign)
    mov ecx, number                     ; Load the address of the input
    movzx edx, byte [ecx]               ; Load the first character

    ; Check if input is negative
    cmp dl, '-'                         ; Compare the character to '-'
    jne check_zero                      ; If not '-', jump to check_zero
    inc ecx                             ; Skip the '-' sign
    movzx edx, byte [ecx]               ; Load the next character

check_zero:
    ; Check if input is zero
    cmp dl, '0'
    je print_zero                       ; If input is '0', jump to print_zero

convert_to_int:
    ; Convert ASCII digits to integer
    sub dl, '0'                         ; Convert ASCII to integer
    imul eax, 10                        ; Multiply the result by 10
    add eax, edx                        ; Add the current digit
    inc ecx                             ; Move to the next character
    movzx edx, byte [ecx]               ; Load the next character
    cmp dl, 10                          ; Check for end of input (newline)
    jl convert_to_int                   ; Loop until the end of input

    ; Classify the number
classify:
    cmp eax, 0                          ; Compare the number with 0
    jg print_positive                   ; If greater than 0, jump to positive
    jl print_negative                   ; If less than 0, jump to negative

print_zero:
    ; Print "ZERO"
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; File descriptor (stdout)
    mov ecx, zero_msg                   ; Address of "ZERO"
    mov edx, 4                          ; Length of "ZERO"
    int 0x80                             ; System call
    jmp exit                            ; Unconditional jump to exit

print_positive:
    ; Print "POSITIVE"
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; File descriptor (stdout)
    mov ecx, pos_msg                    ; Address of "POSITIVE"
    mov edx, 8                          ; Length of "POSITIVE"
    int 0x80                             ; System call
    jmp exit                            ; Unconditional jump to exit

print_negative:
    ; Print "NEGATIVE"
    mov eax, 4                          ; sys_write
    mov ebx, 1                          ; File descriptor (stdout)
    mov ecx, neg_msg                    ; Address of "NEGATIVE"
    mov edx, 8                          ; Length of "NEGATIVE"
    int 0x80                             ; System call
    jmp exit                            ; Unconditional jump to exit

exit:
    ; Exit the program
    mov eax, 1                          ; sys_exit
    xor ebx, ebx                        ; Exit code 0
    int 0x80                             ; System call
