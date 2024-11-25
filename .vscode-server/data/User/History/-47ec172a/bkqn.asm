section .data
    prompt db "Enter 5 integers: ", 0
    output_prompt db "Reversed array: ", 0
    newline db 10, 0                     ; Newline for formatting output

section .bss
    array resd 5                         ; Reserve space for 5 integers

section .text
    global _start

_start:
    ; Print the prompt for input
    mov eax, 4                            ; sys_write
    mov ebx, 1                            ; File descriptor (stdout)
    mov ecx, prompt                       ; Address of the prompt string
    mov edx, 19                           ; Length of the prompt string
    int 0x80                               ; System call

    ; Accept 5 integers from the user
    mov ecx, 5                            ; Loop counter (5 integers)
    mov ebx, array                        ; Address of the array

input_loop:
    mov eax, 3                            ; sys_read
    mov edx, 4                            ; Number of bytes to read (4 bytes for an integer)
    int 0x80                               ; System call
    add ebx, 4                            ; Move to the next integer in the array
    loop input_loop                       ; Repeat for 5 integers

    ; Reverse the array in place (using two pointers: one from the start, one from the end)
    mov ecx, 0                            ; Start index (pointer)
    mov edx, 4                            ; Size of an integer (4 bytes)
    lea ebx, [array + 16]                 ; End address of the array (5 integers * 4 bytes = 20 bytes)

reverse_loop:
    cmp ecx, 2                            ; If start index >= 2 (half of array), stop
    jge reverse_done

    ; Swap elements at array[ecx] and array[ebx]
    mov eax, [array + ecx*4]              ; Load value from the start of the array
    mov edx, [ebx]                        ; Load value from the end of the array
    mov [array + ecx*4], edx              ; Store the swapped value at the start of the array
    mov [ebx], eax                        ; Store the swapped value at the end of the array

    ; Adjust pointers
    inc ecx                                ; Increment the start index
    sub ebx, 4                             ; Decrement the end index
    jmp reverse_loop                       ; Repeat until all elements are swapped

reverse_done:
    ; Print the reversed array
    mov eax, 4                            ; sys_write
    mov ebx, 1                            ; File descriptor (stdout)
    mov ecx, output_prompt                ; Output message
    mov edx, 15                           ; Length of the message
    int 0x80                               ; System call

    ; Loop through and output the reversed array
    mov ecx, 5                            ; Loop counter (5 integers)
    lea ebx, [array]                       ; Address of the array

output_loop:
    mov eax, [ebx]                        ; Load current array value
    call PrintInteger                     ; Call to print the integer
    mov eax, 4                            ; sys_write
    mov ebx, 1                            ; File descriptor (stdout)
    mov ecx, newline                      ; Print newline
    mov edx, 1                            ; Length of newline (1 byte)
    int 0x80                               ; System call

    add ebx, 4                            ; Move to next integer in the array
    loop output_loop                      ; Repeat for all integers

exit:
    ; Exit the program
    mov eax, 1                            ; sys_exit
    xor ebx, ebx                          ; Exit code 0
    int 0x80                               ; System call

PrintInteger:
    ; Print an integer (eax contains the integer to print)
    push eax
    mov eax, 4                            ; sys_write
    mov ebx, 1                            ; File descriptor (stdout)
    lea ecx, [esp]                        ; Address of the integer in the stack
    mov edx, 4                            ; Length (size of an integer)
    int 0x80                               ; System call
    pop eax
    ret
