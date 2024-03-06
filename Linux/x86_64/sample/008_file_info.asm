%include "lib/include/ascii.inc"
%include "lib/include/stdio.inc"

section .data
    filename db '/home/ragingo/temp/cat.bmp', NULL
    message_succeeded db 'filesize: ', NULL
    message_failed db 'fstat failed. error: ', NULL

    ; https://github.com/torvalds/linux/blob/v5.15/arch/x86/include/uapi/asm/stat.h#L83-L104
    struc stat
        .st_dev       resq 1
        .st_ino       resq 1
        .st_mode      resq 1
        .st_nlink     resd 1
        .st_uid       resd 1
        .st_gid       resd 1
        .__pad0       resd 1

        .st_rdev      resq 1
        .st_size      resq 1
        .st_blksize   resq 1
        .st_blocks    resq 1

        .st_atim      resq 1
        .st_atim_nsec resq 1
        .st_mtim      resq 1
        .st_mtim_nsec resq 1
        .st_ctim      resq 1
        .st_ctim_nsec resq 1

        .__unused     resq 3
    endstruc

section .text
    global sample008_file_info
    extern fopen
    extern sys_write
    extern sys_fstat
    extern putchar
    extern print
    extern println
    extern print_number

sample008_file_info:
    push rbp
    mov rbp, rsp

    mov rdi, filename
    push 'r'
    mov rsi, rsp
    call fopen
    pop r8 ; 破棄
    mov r8, rax ; fd

    sub rsp, stat_size
    mov rdi, rax
    mov rsi, rsp
    call sys_fstat

    cmp rax, 0
    jl .sample008_file_info.failed

    push rsi

    mov rdi, message_succeeded
    xor rsi, rsi
    call print

    pop rsi

    mov edi, dword [rsi + stat.st_size]
    xor rsi, rsi
    call print_number
    jmp .sample008_file_info.done

.sample008_file_info.failed:
    mov rdi, message_failed
    xor rsi, rsi
    call print

    mov rdi, rax
    xor rsi, rsi
    call print_number

.sample008_file_info.done:
    leave
    ret

