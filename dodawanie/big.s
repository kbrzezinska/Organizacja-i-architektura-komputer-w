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

movl $3,%edi #zaczynamy numeracje od konca, konwencja little endin
clc   #czyścimy flage przeniesienia

loop:

pushl l1(,%edi,4)    #pierwszy argument funkcji
pushl l2(,%edi,4)    #drugi argument funkcji
call add
pop %eax              #pozbywamy sie ze stosu ostatniego pusha, czyli l2(,%edi,4) zeby na koncu byl widoczny tylko wynik zapisany w l1
movl (%esp),%eax      #wynik pierwszego dodawania do eax
movl %eax,l1(,%edi,4) #eax do czesci l1
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
adcl %eax,12(%ebp)   #dodanie przeniesienia do wyniku, który jest rownoczesnie naszym pierwszym argumentem(l1)

movl 8(%ebp), %eax    #drugi argument funkcji(l2) do eax
adcl  %eax,12(%ebp)   #dodanie pierwszego elementu do drugiego, czyli l1=l1+l2, wynik w 12(%ebp)

setc carry             #ustawiamy przeniesienie w zmiennnej carry, 1- jest, 0- nie ma


end:
movl %ebp, %esp
popl %ebp 
ret






