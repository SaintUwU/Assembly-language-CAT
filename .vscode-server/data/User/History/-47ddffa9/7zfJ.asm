section .data
    prompt db "Enter a positive integer: ", 0
    prompt_len equ $ - prompt
    newline db 10, 0
    result_msg db "Factorial: ", 0
    result_msg_len equ $ - result_msg

section .bss
    num resb 4 ; Reserve space for input number
    factorial resq 1 ; Reserve space for the factorial result (8 bytes for 64-bit)

section .text
    global _start

_start:
    ; Print the prompt
    mov rax, 1 ; sys_write
    mov rdi, 1 ; File descriptor (stdout)
    mov rsi, prompt ; Address of the prompt message
    mov rdx, prompt_len ; Length of the prompt
    syscall

    ; Read input
    mov rax, 0 ; sys_read
    mov rdi, 0 ; File descriptor (stdin)
    mov rsi, num ; Address to store input
    mov rdx, 4 ; Maximum number of bytes to read
    syscall

    ; Convert ASCII input to integer
    movzx rax, byte [num] ; Load first byte of input
    sub rax, '0' ; Convert ASCII to integer
    mov rdi, rax ; Store the input number in rdi (to pass to factorial subroutine)

    ; Call factorial subroutine
    call factorial_sub

    ; Result is in rax; store it in memory
    mov [factorial], rax

    ; Print result message
    mov rax, 1 ; sys_write
    mov rdi, 1 ; File descriptor (stdout)
    mov rsi, result_msg ; Address of the result message
    mov rdx, result_msg_len ; Length of the result message
    syscall

    ; Convert the result to ASCII and print it
    mov rax, [factorial] ; Load factorial result
    call print_number ; Call subroutine to print the number

    ; Exit program
    mov rax, 60 ; sys_exit
    xor rdi, rdi ; Exit code 0
    syscall

; Subroutine: factorial_sub
; Calculates factorial of rdi
factorial_sub:
    push rbx ; Save rbx on the stack
    mov rbx, rdi ; Copy n to rbx
    mov rax, 1 ; Initialize result to 1

.factorial_loop:
    cmp rbx, 1 ; While rbx > 1
    jle .done ; If rbx <= 1, exit loop
    mul rbx ; Multiply rax by rbx
    dec rbx ; Decrement rbx
    jmp .factorial_loop ; Repeat loop

.done:
    pop rbx ; Restore rbx
    ret ; Return to caller

; Subroutine: print_number
; Prints a number in rax as ASCII
print_number:
    push rbx ; Save rbx on the stack
    push rcx ; Save rcx on the stack
    push rdx ; Save rdx on the stack

    mov rcx, 10 ; Divisor (10)
    xor rbx, rbx ; Index for digits (initialize to 0)
    xor rdx, rdx ; Clear rdx (remainder)

.convert_loop:
    xor rdx, rdx ; Clear remainder
    div rcx ; Divide rax by 10, remainder in rdx, quotient in rax
    add dl, '0' ; Convert remainder to ASCII
    push rdx ; Push ASCII digit onto stack
    inc rbx ; Increment digit count
    test rax, rax ; Check if quotient is zero
    jnz .convert_loop ; If not, repeat

.print_digits:
    dec rbx ; Decrement digit count
    jl .done_printing ; If no more digits, exit loop
    pop rax ; Pop digit from stack
    mov [num], al ; Store character in num buffer

    ; Print character
    mov rax, 1 ; sys_write
    mov rdi, 1 ; File descriptor (stdout)
    mov rsi, num ; Address of the character
    mov rdx, 1 ; Length (1 byte)
    syscall
    jmp .print_digits ; Continue printing digits

.done_printing:
    ; Print newline
    mov rax, 1 ; sys_write
    mov rdi, 1 ; File descriptor (stdout)
    mov rsi, newline ; Address of the newline character
    mov rdx, 1 ; Length (1 byte)
    syscall

    ; Restore registers
    pop rdx
    pop rcx
    pop rbx
    ret ; Return to caller