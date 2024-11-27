section .data
    number db 5            ; Input number for factorial (change as needed)
    result dd 0            ; Variable to store the factorial result

section .text
    global _start          ; Entry point for the program

_start:
    ; Load the input number into a register
    movzx eax, byte [number] ; Load input number into EAX (zero-extended)
    
    ; Call the factorial subroutine
    push eax               ; Save input number on the stack
    call factorial         ; Call factorial subroutine
    add esp, 4             ; Clean up stack (remove input number)

    ; Store the result in memory
    mov [result], eax      ; Store factorial result from EAX into memory

    ; Exit program (Linux syscall)
    mov eax, 60            ; Syscall: exit
    xor edi, edi           ; Status: 0
    syscall

; Subroutine: factorial
; Calculates factorial of a number using recursion
factorial:
    push ebp               ; Save base pointer
    mov ebp, esp           ; Establish new stack frame
    push ebx               ; Save EBX register

    mov ebx, [ebp+8]       ; Retrieve the input parameter from the stack

    cmp ebx, 1             ; Check if the number is <= 1
    jle base_case          ; If yes, jump to base case

    dec ebx                ; Calculate (n-1)
    push ebx               ; Push (n-1) onto the stack
    call factorial         ; Recursive call to factorial
    add esp, 4             ; Clean up stack (remove (n-1))
    
    mov ebx, [ebp+8]       ; Reload original number
    mul ebx                ; Multiply EAX (result of factorial(n-1)) by EBX

    jmp end_factorial      ; Jump to end of subroutine

base_case:
    mov eax, 1             ; Base case: factorial(0) or factorial(1) = 1

end_factorial:
    pop ebx                ; Restore EBX register
    pop ebp                ; Restore base pointer
    ret                    ; Return to caller

