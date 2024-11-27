section .data
    sensor_data db 50            ; Simulated sensor value (e.g., 50)
    motor_control db 0           ; Motor control status (0 = off, 1 = on)
    alarm_status db 0            ; Alarm status (0 = off, 1 = on)
    high_threshold db 80         ; Threshold for high water level (alarm)
    low_threshold db 40          ; Threshold for low water level (motor on)

section .text
    global _start

_start:
    ; Read sensor value (simulated from 'sensor_data')
    mov al, [sensor_data]         ; Load the sensor value into AL register

    ; Compare the sensor value with the high threshold (80)
    cmp al, [high_threshold]
    jg trigger_alarm              ; If sensor value > 80, trigger alarm

    ; Compare the sensor value with the low threshold (40)
    cmp al, [low_threshold]
    jl turn_motor_on              ; If sensor value < 40, turn motor on

stop_motor:
    ; Stop the motor (set motor_control to 0)
    mov byte [motor_control], 0   ; Stop motor
    jmp end_program               ; Jump to end of program

turn_motor_on:
    ; Turn on the motor (set motor_control to 1)
    mov byte [motor_control], 1   ; Start motor
    jmp end_program               ; Jump to end of program

trigger_alarm:
    ; Trigger alarm (set alarm_status to 1)
    mov byte [alarm_status], 1    ; Set alarm
    jmp end_program               ; Jump to end of program

end_program:
    ; Exit the program
    mov rax, 60                   ; sys_exit system call number
    xor rdi, rdi                  ; Exit code 0
    syscall                       ; Perform the system call
