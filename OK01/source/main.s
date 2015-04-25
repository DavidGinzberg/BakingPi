.section .init
.globl _start
_start:

ldr r0,=0x20200000  ;GPIO controller address
mov r1,#1
lsl r1,#18          ;Pin 16 is sixth bit-triplet in the GPIO 10-19 block -- 6x3=18
str r1,[r0,#4]      ;Load r1 into GPIO controller DWORD 2
mov r1,#1
lsl r1,#16          
str r1,[r0,#40]     ;GPIO Pin Off address (GPIO+28 is on)

loop$:

b loop$
