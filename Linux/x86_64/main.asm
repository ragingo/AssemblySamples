section .text
    global _start
    extern sys_exit
    extern sample001_helloworld
    extern sample002_alphabet
    extern sample003_strlen
    extern sample004_itoa
    extern sample005_kuku
    extern sample006_file_write

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    call sample001_helloworld
    call sample002_alphabet
    call sample003_strlen
    call sample004_itoa
    call sample005_kuku
    call sample006_file_write

    call temp_samples

    mov rdi, rax
    call sys_exit

; ==========

%include "lib/include/ascii.inc"
%include "lib/include/bit.inc"

temp_samples:
    call temp_sample1
    ret

section .text
    extern byteswap16
    extern byteswap32
    extern byteswap64
    extern print_number
    extern putchar

temp_sample1:
    mov rdi, MAKE_WORD('A', 'B')
    call byteswap16
    cmp rax, MAKE_WORD('A', 'B')
    je .temp_sample1.failure
    cmp rax, MAKE_WORD('B', 'A')
    je .temp_sample1.success
.temp_sample1.failure:
    mov rdi, 0 ; false
    mov rsi, 0
    call print_number ; MEMO: 16進で出力できるようにしたい
    jmp .temp_sample1.finish
.temp_sample1.success:
    mov rdi, 1 ; true
    mov rsi, 0
    call print_number
.temp_sample1.finish:
    mov rdi, ASCII_LF
    call putchar
    ret
