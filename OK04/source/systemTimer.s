.globl getSystemTimerAddress
getSystemTimerAddress:
ldr r0, =0x20003000
mov pc, lr

.globl systemWaitMilli
systemWaitMilli:
lsl r0, #10   ;@ Multiply milliseconds by ~1k to get approximate microseconds
;@ WARNING this timer is off by 1.44 seconds every minute
b systemWait

;@bonus: catch the call to systemWait, test the wait time, and call shortWait
;@  or longWait depending on whether there is enough time to set a comparison
;@  register on the system timer (getSystemTimerAddress + 12, 16, or 20)
.globl systemWait
systemWait:
waitTime .req r0
push {lr}
push {r4}     ;@ Preserve value in R4
push {r3}     ;@ Preserve value in R3
push {r2}     ;@ Preserve value in R2
push {r1}     ;@ Preserve value in R1
mov r4, r0     ;@ Switch waitTime to r4
.unreq waitTime
waitTime .req r4
bl getSystemTimerAddress
mov r2, r0    ;@ Move timer address to R2
ldrd r0, r1, [r2, #4] ;@Get system clock value
goalTime .req r3
;@ Add r0 and waitTime to get 4-byte goalTime
add goalTime, waitTime, r0

waitLoop$:     ;@ Keep fetching and comparing clock until it's bigger
ldrd r0, r1, [r2, #4]
cmp goalTime, r0
bhi waitLoop$

.unreq goalTime
.unreq waitTime
pop {r1}      ;@ Restore value in R1
pop {r2}      ;@ Restore value in R2
pop {r3}      ;@ Restore value in R3
pop {r4}      ;@ Restore value in R4
pop {pc}      ;@ return (pop old lr value into pc)

