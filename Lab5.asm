print macro char
    push ax
    mov al,char
    mov ah,0Eh
    int 10h
    pop ax
endm

org 100h

jmp start

first_input_message db 'Enter first number: $'
operation_message db "Enter the operator: $"
second_input_message db "Enter second number: $"
result_message db  0dh,0ah , 'Result : $'  
error_message db  "Wrong operation!", 0Dh,0Ah , '$'
little db " and a litle$"
user_operation db '?'

num1 dw ?
num2 dw ?
accurency dw 3
start:

lea dx, first_input_message
mov ah, 09h
int 21h

call check
mov num1,cx

print 0Dh
print 0Ah

lea dx,operation_message
mov ah,09h
int 21h

mov ah,1
int 21h
mov user_operation,al

print 0Dh
print 0Ah

cmp user_operation, '.'
je unknown_operation

cmp user_operation, ','
je unknown_operation 

cmp user_operation, '*'
jb unknown_operation

cmp user_operation, '/'
ja unknown_operation 

lea dx,second_input_message
mov ah,09h
int 21h

call check
mov num2,cx 

lea dx,result_message
mov ah,09h
int 21h

cmp user_operation, '+'
je plus

cmp user_operation,'-'
je minus

cmp user_operation,'*'
je multiplication

cmp user_operation,'/'
je division


plus:
mov bx,10
mov ax,num1
add ax,num2

call print_res
jmp exit

minus:
mov ax,num1
sub ax,num2
call print_res
jmp exit

multiplication:
mov ax,0
cmp ax,0
je minuschecker
multimain:

mov ax,num1


imul num2
call mulprint
jmp exit

minuschecker:
cmp num1,0
jl negativ1
cmp num2,0
jl negativ2
jmp multimain

negativ1:
neg num1
jmp negativ3
negativ3:
cmp num2,0
jnl miinus
neg num2
jmp multimain
negativ2:
neg num2
print '-'
jmp multimain

miinus:
print '-'
jmp multimain
 
 
 
    
division:
mov dx,0
mov ax,num2
cmp ax,0
jl haha2
haha3:
mov ax,num1
cmp ax,0
jl dodo

haha:
idiv num2

call print_res
cmp dx,0
jne dop_print
jmp exit

dop_print:
print '.'
jmp loop12

loop12:

cmp accurency,0
jne loop0
jmp exit

loop0:
dec accurency
mov ax,dx
mul CS:ten 
div num2
cmp dx,0
call print_res
jmp loop12
haha1:
neg num2
neg ax
jmp haha
dodo:
    cmp num2,0
    jl haha1
    neg ax
    print '-'
    jmp haha
haha2:
    neg num1
    neg num2
    jmp haha3
    

    
unknown_operation:
    lea dx,error_message
    mov ah, 09h
    int 21h
    jmp exit 
        
exit:
    mov ah,0
    int 16h
    ret
    
check proc near
    push dx
    push ax
    push si
    
    mov cx,0
    mov CS:make_minus,0

next:
    mov ah,00h
    int 16h

    mov ah,0Eh
    int 10h

    cmp al,'-'
    je set_minus 

    cmp al,0Dh
    jne not_cr
    jmp stop

not_cr:
    cmp al,8
    jne backspace:
    mov dx,0
    mov ax,cx
    div CS:ten
    mov cx,ax
    print ' '
    print 8
    jmp next 
    
backspace:
    cmp al,'0'
    jae dig_check
    jmp remove 
    
dig_check:
    cmp al,'9'
    jbe ok 
    
remove:
    print 8
    print ' '
    print 8
    jmp next

ok:
    push ax
    mov ax,cx
    mul CS:ten
    mov cx,ax
    pop ax
    
    cmp dx,0
    jne big 
    
    sub al,30h
    
    mov ah,0
    mov dx,cx
    add cx,ax
    jc big2
    
    jmp next  


big:
    mov ax,cx
    div CS:ten
    mov cx,ax
    print 8
    print ' '
    print 8
    jmp next

big2:
    mov cx,dx
    mov dx,0

set_minus:
    mov CS:make_minus,1
    jmp next
    
stop:
    cmp CS:make_minus, 0
    je not_minus
    neg cx
not_minus:
    pop si
    pop ax
    pop dx
    ret
make_minus db ?
check endp


print_res proc near
    push dx
    push ax
    
    cmp ax,0
    jnz not_zero
    
    print '0'
    jmp done

not_zero:
    cmp ax,0
    jns morezero
    neg ax
    print '-'

morezero:
    call print_all_num

done:
    pop ax
    pop dx
    ret
print_res endp    
    

print_all_num proc near
    push ax
    push bx
    push cx
    push dx
    
    mov cx,1
    mov bx,10000
    cmp ax,0
    jz print_zero

printing:
    cmp bx,0
    jz end_print
    cmp cx,0
    je calculate
    cmp ax,bx
    jb skip

calculate:
    mov cx,0
    mov dx,0
    div bx
    
    add al,30h
    print al
    mov ax,dx

skip:
    push ax
    mov dx,0
    mov ax,bx
    div CS:ten
    mov bx,ax
    pop ax
    jmp printing  
    
end_print:
    pop dx
    pop cx
    pop bx
    pop ax
    ret         
print_zero:
    print '0'
print_all_num endp



ten dw 10
temp dw 2 dup(?)     
;**********************************************************

mulprint proc
    mov     word ptr temp[0],       ax
    mov     word ptr temp[2],       dx
    
    mov bx,10
    mov di,0
NextDigit:
    mov cx,2
    mov si,2
    mov dx,0
DivBy10:
    mov ax, word ptr temp[si]
    div bx
    mov word ptr temp[si],ax
    sub si,2
    loop DivBy10
    add dl,'0'
    push dx
    inc di
    mov ax, word ptr temp[0]
    or ax,word ptr temp[0]
    jnz NextDigit 
    
    mov cx,di
    mov ah,02h
ShowDigit:
    pop dx
    int 21h
    loop ShowDigit
    ret
    
mulprint endp 



