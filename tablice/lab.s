SYSCALL32 = 0x80
EXIT = 1
STDIN = 0
READ = 3
STDOUT = 1
WRITE = 4 


.data
format: .asciz "wynik funkcji suma= %d\n" 

.global suma
.global myTime
.text

myTime:
	push %ebx
	xor %eax,%eax
	cpuid
	rdtsc
	pop %ebx
	ret



suma:

    pushl %ebp
    movl %esp,%ebp
    movl 8(%ebp),%eax   #pierwszy argument
    movl 12(%ebp),%edx  #drugi argument
    addl %edx,%eax
	
	
	push %eax
	push $format
  	call printf 

	pop %eax
	pop %eax

	push %eax	
  	call fibb 
	pop %eax

	leave
    ret



