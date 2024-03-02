%include "lib/include/bit.inc"

section .data
    filename db '/home/ragingo/temp/a.bmp', 0

    ; https://learn.microsoft.com/ja-jp/windows/win32/api/wingdi/ns-wingdi-bitmapfileheader
    struc BITMAPFILEHEADER
        .bfType      resw 1
        .bfSize      resd 1
        .bfReserved1 resw 1
        .bfReserved2 resw 1
        .bfOffBits   resd 1
    endstruc

    ; https://learn.microsoft.com/ja-jp/windows/win32/api/wingdi/ns-wingdi-bitmapinfoheader
    struc BITMAPINFOHEADER
        .biSize          resd 1
        .biWidth         resd 1
        .biHeight        resd 1
        .biPlanes        resw 1
        .biBitCount      resw 1
        .biCompression   resd 1
        .biSizeImage     resd 1
        .biXPelsPerMeter resd 1
        .biYPelsPerMeter resd 1
        .biClrUsed       resd 1
        .biClrImportant  resd 1
    endstruc

section .text
    global sample007_bmp_create
    extern fopen
    extern sys_write

%define BI_RGB 0
%define BITMAP_HEADER_SIZE (BITMAPFILEHEADER_size + BITMAPINFOHEADER_size)
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
    mov word  [rdi + BITMAPFILEHEADER.bfType],      MAKE_WORD('B', 'M')
    mov dword [rdi + BITMAPFILEHEADER.bfSize],      BITMAP_FILE_SIZE
    mov word  [rdi + BITMAPFILEHEADER.bfReserved1], 0
    mov word  [rdi + BITMAPFILEHEADER.bfReserved2], 0
    mov dword [rdi + BITMAPFILEHEADER.bfOffBits],   BITMAP_PIXEL_OFFSET

    ; info header
    mov rax, BITMAPFILEHEADER_size
    mov dword [rdi + rax + BITMAPINFOHEADER.biSize],          BITMAPINFOHEADER_size
    mov dword [rdi + rax + BITMAPINFOHEADER.biWidth],         BITMAP_WIDTH
    mov dword [rdi + rax + BITMAPINFOHEADER.biHeight],        BITMAP_HEIGHT
    mov word  [rdi + rax + BITMAPINFOHEADER.biPlanes],        1
    mov word  [rdi + rax + BITMAPINFOHEADER.biBitCount],      BITMAP_BITS_PER_PIXEL
    mov dword [rdi + rax + BITMAPINFOHEADER.biCompression],   BI_RGB
    mov dword [rdi + rax + BITMAPINFOHEADER.biSizeImage],     BITMAP_DATA_SIZE
    mov dword [rdi + rax + BITMAPINFOHEADER.biXPelsPerMeter], 0
    mov dword [rdi + rax + BITMAPINFOHEADER.biYPelsPerMeter], 0
    mov dword [rdi + rax + BITMAPINFOHEADER.biClrUsed],       0
    mov dword [rdi + rax + BITMAPINFOHEADER.biClrImportant],  0

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
