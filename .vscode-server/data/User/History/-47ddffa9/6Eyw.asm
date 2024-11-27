section .data
    number dq 5             ; Input number for factorial (64-bit)
    result dq 0             ; Variable to store the factorial result

section .text
    global _start           ; Entry point for the program

_start:
    ; Step 1: Load the input number into RDI (first function argument register)
    mov rdi, [number]       ; Load the input number (stored in 'number') into RDI

    ; Step 2: Call the factorial subroutine
    call factorial          ; Call factorial subroutine

    ; Step 3: Store the result (in RAX) into the 'result' variable
    mov [result], rax       ; Store the result from RAX into memory

    ; Exit program (Linux syscall)
    mov rax, 60             ; Syscall: exit
    xor rdi, rdi            ; Status: 0
    syscall

; Subroutine: factorial
factorial:
    ; Step 4: Save registers to the stack (preserve state)
    push rbx                ; Save RBX (used as a temporary register)
    push rbp                ; Save RBP (used for stack frame)
    
    ; Step 5: The input number is passed in RDI
    mov rbx, rdi            ; Copy input number (RDI) into RBX for processing

    ; Step 6: Check if the number is <= 1 (base case)
    cmp rbx, 1
    jle base_case           ; If number <= 1, jump to base case

    ; Step 7: Recursive case - Calculate factorial(n-1)
    dec rbx                 ; Decrement the number (n-1)
    mov rdi, rbx            ; Move (n-1) into RDI for the recursive call
    call factorial          ; Recursive call to factorial(n-1)

    ; Step 8: After returning from the recursive call, multiply the result by n
    mov rbx, rdi            ; Reload the original number (n) into RBX
    imul rax, rbx           ; Multiply the result (in RAX) by the original number (in RBX)

    ; Step 9: Restore registers and return
    pop rbp                 ; Restore RBP
    pop rbx                 ; Restore RBX
    ret                     ; Return to the caller

base_case:
    ; Step 10: Base case (factorial(1) or factorial(0)) = 1
    mov rax, 1              ; Set RAX to 1 (base case result)
    pop rbp                 ; Restore RBP
    pop rbx                 ; Restore RBX
    ret                     ; Return to the caller
