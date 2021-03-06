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
