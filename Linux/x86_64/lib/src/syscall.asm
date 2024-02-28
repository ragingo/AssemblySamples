%include "lib/include/syscall.inc"

section .text
    extern strlen
    global sys_read
    global sys_write
    global sys_open
    global sys_lseek
    global sys_creat
    global sys_nanosleep
    global sys_exit

;==================================================
; Description
;   read system call
; Parameters
;   rdi: fd, rsi: buf, rdx: count
;==================================================
sys_read:
    system_call SYS_READ
    ret

;==================================================
; Description
;   write system call
; Parameters
;   rdi: fd, rsi: buf, rdx: count
;==================================================
sys_write:
    system_call SYS_WRITE
    ret

;==================================================
; Description
;   open system call
; Parameters
;   rdi: filename, rsi: flags, rdx: mode (permission)
; Returns
;   rax: fd
;==================================================
sys_open:
    system_call SYS_OPEN
    ret

;==================================================
; Description
;   lseek system call
; Parameters
;   rdi: fd, rsi: offset, rdx: whence
; Returns
;   rax: offset or -1
;==================================================
sys_lseek:
    system_call SYS_LSEEK
    ret

;==================================================
; Description
;   creat system call
; Parameters
;   rdi: filename, rsi: mode (permission)
; Returns
;   rax: fd
;==================================================
sys_creat:
    system_call SYS_CREAT
    ret

;==================================================
; Description
;   nanosleep system call
; Parameters
;   rdi: const struct timespec *req, rsi: struct timespec *rem
;==================================================
sys_nanosleep:
    system_call SYS_NANOSLEEP
    ret

;==================================================
; Description
;   exit system call
; Parameters
;   rdi: exit code
;==================================================
sys_exit:
    system_call SYS_EXIT
    ret
