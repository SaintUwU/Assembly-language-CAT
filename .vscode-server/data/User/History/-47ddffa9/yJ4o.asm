section .data
    prompt db "Enter a number: ", 0
    prompt_len equ $ - prompt
    newline db 10, 0

section .bss
    num resb 4      ; Reserve space for the number input by the user
    result resb 16  ; Reserve space to store the result (max size for integer output)

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1          ; sys_write
    mov rdi, 1          ; File descriptor (stdout)
    mov rsi, prompt     ; Address of the prompt string
    mov rdx, prompt_len ; Length of the prompt string
    syscall

    ; Read user input (number)
    mov rax, 0          ; sys_read
    mov rdi, 0          ; File descriptor (stdin)
    mov rsi, num        ; Address of input buffer
    mov rdx, 4          ; Read 4 bytes (max integer input)
    syscall

    ; Convert input from ASCII to integer
    movzx rsi, byte [num]  ; Load the first byte (ASCII character)
    sub rsi, '0'            ; Convert ASCII to integer

    ; Calculate factorial (using loop)
    mov rbx, rsi          ; Store the number in rbx
    mov rax, 1            ; Set rax to 1 (start factorial calculation)

factorial_loop:
    cmp rbx, 1            ; Check if rbx (counter) is 1
    jle factorial_done    ; If rbx <= 1, factorial calculation is done

    imul rax, rbx         ; Multiply rax by rbx (factorial calculation)
    dec rbx               ; Decrement rbx
    jmp factorial_loop    ; Repeat the loop

factorial_done:
    ; Convert the result from integer to ASCII
    mov rdi, result       ; Store result in the result buffer
    mov rsi, rax          ; Move result into rsi

    ; Convert integer to string (ASCII)
    mov rbx, 10           ; Divisor (base 10)
    xor rcx, rcx          ; Clear rcx (digit counter)

convert_loop:
    xor rdx, rdx          ; Clear rdx (remainder)
    div rbx               ; Divide rsi by 10, quotient in rax, remainder in rdx
    add dl, '0'           ; Convert remainder to ASCII
    mov [rdi + rcx], dl   ; Store the ASCII character
    inc rcx               ; Move to the next character
    test rax, rax         ; Check if quotient is 0
    jnz convert_loop      ; If not zero, continue

    ; Print the result (factorial value)
    mov rax, 1            ; sys_write
    mov rdi, 1            ; File descriptor (stdout)
    mov rsi, result       ; Address of result string
    mov rdx, rcx          ; Length of result string
    syscall
    
reverse_loop:
    cmp r12, rcx          ; Check if left index >= right index
    jge print_array       ; If so, we are done with reversing

    ; Swap characters at r12 and rcx
    mov al, [rdi + r12]
    mov bl, [rdi + rcx]
    mov [rdi + r12], bl
    mov [rdi + rcx], al

    inc r12               ; Move left index to the right
    dec rcx               ; Move right index to the left
    jmp reverse_loop      ; Repeat the loop

    ; Print newline
    mov rax, 1            ; sys_write
    mov rdi, 1            ; File descriptor (stdout)
    mov rsi, newline      ; Newline character
    mov rdx, 1            ; Length of newline
    syscall

    ; Exit program
    mov rax, 60           ; sys_exit
    xor rdi, rdi          ; Exit code 0
    syscall
