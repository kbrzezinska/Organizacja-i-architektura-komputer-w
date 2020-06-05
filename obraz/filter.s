SYSCALL32 = 0x80
EXIT = 1
STDIN = 0
READ = 3
STDOUT = 1
WRITE = 4 


.data
mask: .8byte 0
ff: .asciz "aaaaaaa=%i"
.type negatyw, @function 
.global negatyw
.type negatyw_reszta, @function 
.text

negatyw:

push %rbp 
mov %rsp, %rbp 

movq $0xffffffffffffffff, %rax #16*4bit=64bit
#movq $0x0808080808080808, %rax #16*4bit=64bit
movq %rax, %mm1 			#

#%rdi pierwszy argument, rsi - drugi
#call pp
#popq %rdi
movq $0,%rax


petla: 
movq (%rdi,%rax,8), %mm0 

pxor %mm1, %mm0 
movq %mm0, (%rdi,%rax,8) 

inc %rax 

cmpq %rsi,%rax
jne petla 

emms 

mov %rbp, %rsp 
pop %rbp 
ret 


