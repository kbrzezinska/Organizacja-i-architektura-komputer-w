SYSCALL32= 0x80
EXIT = 1
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0
BUF_SIZE=254

.data

TEXT_SIZE: .long 0
BUF: .space BUF_SIZE
BUF2: .space BUF_SIZE
check: .byte 0b00100000 #0x20
.global _start
.text

_start:
movl $BUF_SIZE, %edx
movl $BUF, %ecx
movl $STDIN, %ebx
movl $READ, %eax
int $SYSCALL32

decl %eax
movl %eax, TEXT_SIZE

#call CHANGE_SIZE_OF_LETTERS
call encrypt


movl TEXT_SIZE, %edx
movl $BUF, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL32

movl $EXIT, %eax
int $SYSCALL32

CHANGE_SIZE_OF_LETTERS:
movl $0, %edi
#inc %edi
loop:

movb BUF(%edi,1), %al
cmpb $'A', %al #jesli litera t
jae change
inc %edi
cmpl TEXT_SIZE, %edi
jb loop    
ret

change:
test check,%al
jz to_small
sub check ,%al      #zmienia male na duże
movb %al,BUF(%edi,1)
inc %edi
cmpl TEXT_SIZE, %edi
jb loop    
ret


to_small: #zmienia duże na male
or check ,%al
movb %al,BUF(%edi,1)
inc %edi
cmpl TEXT_SIZE, %edi
jb loop    
ret


encrypt:
movl $0, %edi

#inc %edi
loop2:
movb BUF(%edi,1), %al
xor $1 ,%al      #zmienia male na duże
movb %al,BUF(%edi,1)
inc %edi
cmpl TEXT_SIZE, %edi
jb loop2    
ret






