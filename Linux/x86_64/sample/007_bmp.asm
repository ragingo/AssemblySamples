%include "lib/include/bit.inc"

section .data
    filename db '/home/ragingo/temp/a.bmp', 0

section .text
    global sample007_bmp
    extern fopen
    extern sys_write

sample007_bmp:
    push rbp
    mov rbp, rsp

    mov rdi, filename
    push 'w'
    mov rsi, rsp
    call fopen
    pop r8 ; 破棄
    mov r8, rax ; fd

    sub rsp, 1024 * 3 + 54
    mov rdi, rsp
    call create_bitmap

    mov r9, rdi

    mov rdi, r8 ; fd
    mov rsi, r9 ; buf
    mov rdx, 1024 * 3 + 54
    call sys_write

    leave
    ret

; rdi: buf
create_bitmap:
    push rbp
    mov rbp, rsp

    ; file header
    mov word [rdi + 0], MAKE_WORD('B', 'M')
    mov dword [rdi + 2], 1024 * 3 + 54
    mov word [rdi + 6], 0
    mov word [rdi + 8], 0
    mov dword [rdi + 10], 54

    ; info header
    mov dword [rdi + 14], 40
    mov dword [rdi + 18], 32
    mov dword [rdi + 22], 32
    mov word [rdi + 26], 1
    mov word [rdi + 28], 24
    mov dword [rdi + 30], 0
    mov dword [rdi + 34], 1024 * 3
    mov dword [rdi + 38], 0
    mov dword [rdi + 42], 0
    mov dword [rdi + 46], 0
    mov dword [rdi + 50], 0

    ; pixels
    call create_bitmap_data
    ; call create_bitmap_data_2

    leave
    ret

create_bitmap_data_2:
    mov rcx, 1024 * 3
.create_bitmap_data_2.loop:
    mov byte [rdi + 54 + rcx], cl
    loop .create_bitmap_data_2.loop
    ret

create_bitmap_data:
    push rbp
    mov rbp, rsp

    push r8
    push r9

    xor r8, r8  ; row

.create_bitmap_data.loop.row:
    xor r9, r9  ; col
.create_bitmap_data.loop.col:
    push r8
    push r9

    ; row * stride + col
    mov rax, r8
    imul rax, 32 * 3
    add rax, r9

    mov byte [rdi + 54 + rax + 0], al
    mov byte [rdi + 54 + rax + 1], al
    mov byte [rdi + 54 + rax + 2], al

    pop r9
    pop r8

    add r9, 3
    cmp r9, 32 * 3
    jl .create_bitmap_data.loop.col

    inc r8
    cmp r8, 32
    jl .create_bitmap_data.loop.row

    pop r9
    pop r8
    leave
    ret
