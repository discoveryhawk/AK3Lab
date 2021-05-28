.syntax unified
.cpu cortex-m4
.thumb
#define a #3
#define b #3
#define c #4
// (a+b)/2+c!
.global vtable_kernel
.global __kernel_reset__
.type vtable_kernel, %object
.type __kernel_reset__, %function
.section .interrupt_vector
vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel
.section .rodata
	data: .asciz "kernel started!\n"
	final: .asciz "Value in register #3: "
.section .text
__kernel_reset__:
	ldr r0, =data
	bl dbgput_line
// calculate 
	mov r0, a
	mov r1, b
	mov r2, c
	bl calc
	ldr r0, =final
	bl dbgput
	mov r0, r3
	bl dbgput_num
calc:
	push { r4, r5, lr }
	add r5, r0, r1
	mov r4, #2
	sdiv r5, r4
	mov r0, r2
	bl factorial
	add r3, r0, r5
	pop { r4, r5, pc }
factorial:
	//param: 1 number
	push { r4 }
	mov r4, 1
	.fact_calc:
		mul r4, r0
		subs r0, #1
		bne .fact_calc
	mov r0, r4
	pop { r4 }
	bx lr
end:
	b end
