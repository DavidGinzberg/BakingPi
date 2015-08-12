.section .init
.globl _start
_start:
b main

.section .text
main:
mov sp, #0x8000

pinNum .req r0
pinFunc .req r1
mov pinNum, #16
mov pinFunc, #1
bl SetGpioFunction
.unreq pinNum
.unreq pinFunc

ptrn .req r4
ldr ptrn, =pattern
ldr ptrn, [ptrn]
seq .req r5
mov seq, #0

;@TODO: rewrite code to use seq to implement pattern with 250ms waits
loop$:		    ;@Loop on the given pattern
pinNum .req r0
pinVal .req r1
mov pinNum, #16
mov pinVal, #1
lsl r1, seq
and r1,ptrn
bl SetGpio
.unreq pinNum
.unreq pinVal

mov r0, #0xFA ;@ Wait approx .25 seconds
bl systemWaitMilli
;@ need to increment seq and reset if gt 32
add seq, #1	;@increment seq
cmp seq, #32
subeq seq, #32	;@reset to zero if 32
b loop$

;@Technically dead code, but unreq for sanity's sake
.unreq seq
.unreq ptrn

.section .data
.align 2
pattern:
.int 0b11111111101010100010001000101010
