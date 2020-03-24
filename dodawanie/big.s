SYSCALL32= 0x80
EXIT = 1
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0

.data

l1: .long 0x00000000, 0xF2345678, 0x9ABCDEF0, 0x10123349 #3*4*8=96 bit
l2: .long 0x00000000, 0x11111111, 0x11111110, 0xf1111111
carry: .long 0x0
.global _start
.text

_start:

movl $3,%edi
clc

loop:

pushl l1(,%edi,4)
pushl l2(,%edi,4)
call add
pop %eax
movl (%esp),%eax
movl %eax,l1(,%edi,4)
dec %edi
cmpl $1,%edi
jge loop

movl carry,%eax
movl %eax,l1(,%edi,4)
push %eax

movl $EXIT, %eax
int $SYSCALL32


.type add @function
add:
push %ebp
movl %esp, %ebp

movl carry,%eax     #dodanie przeniesienia
adcl %eax,12(%ebp)

movl 8(%ebp), %eax #pierwszy argument funkcji
adcl  %eax,12(%ebp)

setc carry


end:
movl %ebp, %esp
popl %ebp 
ret






