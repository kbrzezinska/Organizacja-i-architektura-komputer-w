SYSCALL32= 0x80
EXIT = 1
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0


.data
f1: .float 0.0
f2: .float -4.2
f3: .float 3.2
f: .float 0.0
word: .2byte 0
sqr: .float 5.0
temp: .long 0
nan: .asciz "wyjatek NaN\n"
zero: .asciz "wyjatek zero\n"
nieskonczonosc: .asciz "wyjatek nieskończoność\n"
brak: .asciz "brak wyjątku\n"

.global excep
.global control
.global fib
.global fpow
.global stan
.global fibb_iter
.global _start

.text
#_start:

#push sqr
#call fib

#movl $EXIT, %eax
#int $SYSCALL32


excep:

finit
//call control

fld f1
fdiv f1	
call stan

fstp f
push f
call pp
pop f

fld f2 
fdiv f1 #-4.2/0
call stan

fstp f
push f
call pp
pop f


fld f3
fdiv f1

call stan
fstp f
push f
call pp
pop f

fld f1
fdiv f2
call stan

fstp f
push f
call pp
pop f

fld f1
fdiv f3

call stan
fstp f
push f
call pp
pop f

ret


control:

fstcw word
fwait
movw word,%ax
and $0xfcff,%ax #single precision
or $0x0200,%ax #double precision info float
push %eax
fldcw (%esp)
pop %eax

ret


stan:

fxam

fstsw %ax
fwait
movw %ax,word
and $0b0100010100000000,%ax

cmp $0b0000000100000000,%ax
je nans

cmp $0b0000001010000000,%ax
je infi

cmp $0b0100000000000000,%ax
je zeros

cmp $0b0000010000000000,%ax
je normal


jmp koniec
normal:
push $brak
call printf 
pop %eax
jmp koniec

infi:
push $nieskonczonosc
call printf 
pop %eax
jmp koniec

zeros:
push $zero
call printf 
pop %eax
jmp koniec

nans:
push $nan
call printf 
pop %eax

koniec:
fclex
ret



fib:
push %ebp
movl %esp, %ebp



fld sqr
fsqrt
fld1 
fadd %st(0),%st(1)
fadd %st(0)
fxch %st(1)
fdiv %st(1) #st0=1+sqr5/2
fstp f

push 8(%ebp) 
push f
call fpow
pop f
pop f
fstp f

fld sqr
fsqrt
fld1 
fsub %st(0),%st(1)
fadd %st(0)
fxch %st(1)
fdiv %st(1) #st0=1-sqr5/2
fchs
fstp f1

push 8(%ebp) 
push f1
call fpow
pop f1
pop f1

fst f1
fprem
fldz
fxch %st(1)
fcomi %st(1)
je dalej
fchs


dalej:
fld sqr
fsqrt
fld f1        #1-sqr5/2
fld f       #1+sqr5/2
fsub %st(1),%st(0)
fdiv %st(2) 


leave
ret

fpow:


push %ebp
movl %esp, %ebp

finit

fstcw word
fwait
movw word,%ax
or $0b110000000000,%ax 
push %eax
fldcw (%esp)
pop %eax


fld 12(%ebp) #2
fld 8(%ebp) #1.5

fyl2x 				#st(1)=st(1)*log(st)
fist temp			#konwertije st do int
fild temp


fsub %st(1),%st(0) #st0=st0-st1 wyjdzie na minusie
fchs 				#st= -st zmiana znaku
f2xm1				#st=2^(st)-1, -1 <= st <= 1
fld1
fadd %st(1),%st(0)

fild temp
fxch 
fscale              #st0 * 2^st1, st1-liczba calkowita 

leave
ret


fibb_iter:
push %ebp
movl %esp, %ebp

movl $2, %ecx #licznik
finit

fld 8(%ebp)
fist temp
fld1
fadd %st


fcom %st(1)
fstsw %ax
sahf 
jae equal


fld1
fxch %st(1)
fsub %st(1)
fldz

fadd %st(2),%st
fadd %st(1),%st

inc %ecx

cmp temp, %ecx
jl loop
jmp end

loop:
fxch %st(2)
fxch %st(1)
fstp f
fldz
fadd %st(2),%st
fadd %st(1),%st

inc %ecx
cmp temp, %ecx
jl loop
jmp end

equal:
fstp f
fldz
fcom %st(1)
fstsw %ax
sahf 
je end
fstp f
fld1

end:
leave
ret








