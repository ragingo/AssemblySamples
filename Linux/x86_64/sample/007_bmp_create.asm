%include "lib/include/bit.inc"

section .data
    filename db '/home/ragingo/temp/a.bmp', 0

section .text
    global sample007_bmp_create
    extern fopen
    extern sys_write

%define BI_RGB 0
%define BITMAPFILEHEADER_SIZE 14
%define BITMAPINFOHEADER_SIZE 40
%define BITMAP_HEADER_SIZE (BITMAPFILEHEADER_SIZE + BITMAPINFOHEADER_SIZE)
%define BITMAP_PIXEL_OFFSET BITMAP_HEADER_SIZE
%define BITMAP_WIDTH 32
%define BITMAP_HEIGHT 32
%define BITMAP_BITS_PER_PIXEL 24
%define BITMAP_DATA_SIZE (BITMAP_WIDTH * BITMAP_HEIGHT * BITMAP_BITS_PER_PIXEL / 8)
%define BITMAP_FILE_SIZE (BITMAP_HEADER_SIZE + BITMAP_DATA_SIZE)
%define BITMAP_ROW_STRIDE (BITMAP_WIDTH * BITMAP_BITS_PER_PIXEL / 8)

sample007_bmp_create:
    push rbp
    mov rbp, rsp

    mov rdi, filename
    push 'w'
    mov rsi, rsp
    call fopen
    pop r8 ; 破棄
    mov r8, rax ; fd

    sub rsp, BITMAP_FILE_SIZE
    mov rdi, rsp
    call create_bitmap

    mov r9, rdi

    mov rdi, r8 ; fd
    mov rsi, r9 ; buf
    mov rdx, BITMAP_FILE_SIZE
    call sys_write

    leave
    ret

; rdi: buf
create_bitmap:
    push rbp
    mov rbp, rsp

    ; file header
    ; https://learn.microsoft.com/ja-jp/windows/win32/api/wingdi/ns-wingdi-bitmapfileheader
    mov word  [rdi +  0], MAKE_WORD('B', 'M')   ; bfType
    mov dword [rdi +  2], BITMAP_FILE_SIZE      ; bfSize
    mov word  [rdi +  6], 0                     ; bfReserved1
    mov word  [rdi +  8], 0                     ; bfReserved2
    mov dword [rdi + 10], BITMAP_PIXEL_OFFSET   ; bfOffBits

    ; info header
    ; https://learn.microsoft.com/ja-jp/windows/win32/api/wingdi/ns-wingdi-bitmapinfoheader
    mov dword [rdi + 14], BITMAPINFOHEADER_SIZE ; biSize
    mov dword [rdi + 18], BITMAP_WIDTH          ; biWidth
    mov dword [rdi + 22], BITMAP_HEIGHT         ; biHeight
    mov word  [rdi + 26], 1                     ; biPlanes
    mov word  [rdi + 28], BITMAP_BITS_PER_PIXEL ; biBitCount
    mov dword [rdi + 30], BI_RGB                ; biCompression
    mov dword [rdi + 34], BITMAP_DATA_SIZE      ; biSizeImage
    mov dword [rdi + 38], 0                     ; biXPelsPerMeter
    mov dword [rdi + 42], 0                     ; biYPelsPerMeter
    mov dword [rdi + 46], 0                     ; biClrUsed
    mov dword [rdi + 50], 0                     ; biClrImportant

    ; pixels
    push rdi
    lea rdi, [rdi + BITMAP_PIXEL_OFFSET]
    call create_bitmap_data
    pop rdi

    leave
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
    imul rax, BITMAP_ROW_STRIDE
    add rax, r9

    mov byte [rdi + rax + 0], al
    mov byte [rdi + rax + 1], al
    mov byte [rdi + rax + 2], al

    pop r9
    pop r8

    add r9, 3
    cmp r9, BITMAP_ROW_STRIDE
    jl .create_bitmap_data.loop.col

    inc r8
    cmp r8, BITMAP_HEIGHT
    jl .create_bitmap_data.loop.row

    pop r9
    pop r8

    leave
    ret
