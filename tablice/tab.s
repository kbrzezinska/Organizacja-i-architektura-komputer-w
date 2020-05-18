
.data
.global fibb

.text
fibb:

	pushl %ebp
    movl %esp,%ebp

	
	movl $0, %eax 	# wynik
	movl $0, %ecx 	#licznik


	cmpl $1,8(%ebp) 
	je jeden
	
	cmp $0,8(%ebp) 
	je zero
	
jmp start

	jeden:
	movl $-5, %eax
	jmp end
	
	zero:
	movl $-4, %eax
	jmp end
start:


	pushl $0
	pushl $1
	inc %ecx

loop:
	movl $0, %eax 
	addl 4(%esp), %eax
	addl (%esp), %eax
	movl (%esp), %edx
	movl %edx, 4(%esp)
	movl %eax, (%esp)
	inc %ecx

	cmp 8(%ebp), %ecx
	jl loop


	pop %ecx
	pop %ecx

	push %eax
  	call print_fibb
	pop %eax
	
	end:
	leave
	ret
