section .text
    global byteswap16
    global byteswap32
    global byteswap64

;==================================================
; Description
;   バイトオーダー変更
; Parameters
;   di: value
; Returns
;   rax
;==================================================
byteswap16:
    movzx rax, di
    rol ax, 8
    ret

;==================================================
; Description
;   バイトオーダー変更
; Parameters
;   edi: value
; Returns
;   rax
;==================================================
byteswap32:
    mov eax, edi
    bswap eax
    ret

;==================================================
; Description
;   バイトオーダー変更
; Parameters
;   rdi: value
; Returns
;   rax
;==================================================
byteswap64:
    mov rax, rdi
    bswap rax
    ret
