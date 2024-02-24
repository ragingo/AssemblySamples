%ifndef _BIT_INC_
%define _BIT_INC_

%define MASK_BYTE(a) (a & 0xff)
%define MAKE_WORD(a, b) ((MASK_BYTE(b) << 8) | MASK_BYTE(a))
%define MAKE_DWORD(a, b, c, d) ((MASK_BYTE(d) << 24) | (MASK_BYTE(c) << 16) | (MASK_BYTE(b) << 24) | MASK_BYTE(a))

%endif
