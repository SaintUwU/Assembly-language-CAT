section .data
    number dq 5             ; Input number for factorial (64-bit)
    result dq 0             ; Variable to store the factorial result

section .text
    global _start           ; Entry point for the program

_start:
    mov rdi, [number]       ; Load the input number into RDI (first argument register)
    call factorial          ; Call the factorial subroutine

    mov [result], rax       ; Store the result from RAX into memory

    ; Exit program (Linux syscall)
    mov rax, 60             ; Syscall: exit
    xor rdi, rdi            ; Status: 0
    syscall

; Subroutine: factorial
factorial:
    push rbp                ; Save base pointer
    mov rbp, rsp            ; Set up stack frame
    push rbx                ; Save RBX (used as a temporary register)

    mov rbx, rdi            ; Copy input argument (RDI) into RBX

    cmp rbx, 1              ; Check if the number is <= 1
    jle base_case           ; If yes, jump to base case

    dec rbx                 ; Decrement the number (n-1)
    mov rdi, rbx            ; Move (n-1) into RDI (argument for recursive call)
    call factorial          ; Recursive call

    mov rbx, rdi            ; Reload the original number into RBX
    imul rax, rbx           ; Multiply RAX (result of factorial(n-1)) by RBX

    jmp end_factorial       ; Jump to end of subroutine

base_case:
    mov rax, 1              ; Base case: factorial(0) or factorial(1) = 1

end_factorial:
    pop rbx                 ; Restore RBX
    pop rbp                 ; Restore base pointer
    ret                     ; Return to caller
