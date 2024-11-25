section .data
    prompt db "Enter two integers: ", 0xA
    newline db 0xA

section .bss
    array resd 2  ; Reserve space for 2 integers (4 bytes each)

section .text
    global _start

_start:
    ; Print the prompt to ask for input
    mov eax, 4                ; sys_write
    mov ebx, 1                ; File descriptor (stdout)
    mov ecx, prompt           ; Address of the prompt string
    mov edx, 20               ; Length of the prompt string
    int 0x80                  ; System call

    ; Accept two integers from the user
    mov ecx, 2                ; Loop counter (2 integers)
    lea ebx, [array]          ; Address of the array

input_loop:
    mov eax, 3                ; sys_read
    mov edx, 4                ; Number of bytes to read (4 bytes for one integer)
    int 0x80                  ; System call
    add ebx, 4                ; Move to the next integer in the array
    loop input_loop           ; Repeat for 2 integers

    ; Print a newline
    mov eax, 4                ; sys_write
    mov ebx, 1                ; File descriptor (stdout)
    mov ecx, newline          ; Newline character
    mov edx, 1                ; Length of the newline (1 byte)
    int 0x80                  ; System call

    ; Print the two integers entered by the user
    mov ecx, 2                ; Loop counter (2 integers)
    lea ebx, [array]          ; Address of the array

print_loop:
    mov eax, [ebx]            ; Load the current array value (integer)
    call PrintInteger         ; Print the integer
    mov eax, 4                ; sys_write
    mov ebx, 1                ; File descriptor (stdout)
    mov ecx, newline          ; Print newline
    mov edx, 1                ; Length of newline (1 byte)
    int 0x80                  ; System call

    add ebx, 4                ; Move to the next integer in the array
    loop print_loop           ; Repeat for all integers

exit:
    ; Exit the program
    mov eax, 1                ; sys_exit
    xor ebx, ebx              ; Exit code 0
    int 0x80                  ; System call

PrintInteger:
    ; Print an integer (eax contains the integer to print)
    push eax
    mov eax, 4                ; sys_write
    mov ebx, 1                ; File descriptor (stdout)
    lea ecx, [esp]            ; Address of the integer in the stack
    mov edx, 4                ; Length (size of an integer)
    int 0x80                  ; System call
    pop eax
    ret
