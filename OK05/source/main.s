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
loop$:		    ;@Loop on turning the ACT led on and off
pinNum .req r0
pinVal .req r1
mov pinNum, #16
mov pinVal, #0
bl SetGpio
.unreq pinNum
.unreq pinVal

@; bl sleep$
mov r0, #0x800 ;@ Wait approx 2 seconds
bl systemWaitMilli

pinNum .req r0
pinVal .req r1
mov pinNum, #16
mov pinVal, #1
bl SetGpio
.unreq pinNum
.unreq pinVal

;@ bl sleep$
;@ bl sleep$
mov r0, #0x1000  ;@ approx 4 seconds
bl systemWaitMilli

b loop$

sleep$:
push {lr}
timer .req r2
mov timer, #0x3F0000
wait$:
sub timer, #1
cmp timer, #0
bne wait$
.unreq timer
pop {pc}

.section .data
.align 2
pattern
.int 0b11111111101010100010001000101010
