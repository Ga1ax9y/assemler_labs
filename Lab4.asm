DATA_SEG    SEGMENT
    message_input  db "Enter a line for sorting: $"  
    message_output db "Result: $"
    message_error  db "Error! $"
    message_source db "Your line: $"
    endline        db 10, 13, '$'
    
    size equ 200
line db size DUP('$')                            
size2 db 0
.code
output macro str ;string output
    mov ah, 9  
    mov dx, offset str   ;peredacha smecheniya do etogo znacheniya
    int 21h ;vizov prerivanie
endm
output2 proc
    push bx
    mov bl,line[1]
    mov size2, bl
    pop bx
    
    mov ah,02h
    mov si,offset line+1
loopp:
    inc si
    dec size2
    mov dx,[si]
    int 21h
    cmp size2,0
    jne loopp
    ret
output2 endp

input macro str ;string input
    mov ah, 0Ah
    mov dx, offset str
    int 21h
endm

    DATA_SEG    ENDS

CODE_SEG    SEGMENT
   ASSUME CS: CODE_SEG, DS:DATA_SEG

    start:         
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    output message_input 
    mov line[0], 197  
    
    input line 
    cmp line[3], '$'
    je error_end
    lea SI, line
    inc si
    inc si
    jmp check_loop

str:
    mov ax, 3
    int 10h  
    
    output message_source   
    mov ah, 9
    mov dx, offset line + 2
    int 21h  
    
    output endline
    output endline
    jmp main_loop
    
main_loop:         
    mov ah, 9
    mov dx, offset line + 2   ;vivod stroki
    int 21h 
    output endline
    ;null registers
    xor si, si
    xor di, di
    xor ax, ax
    xor dx, dx    
    mov si, offset line + 2 ;start of string
    
first_word:       
    cmp byte ptr[si], 9
    je error_end
    
    cmp byte ptr[si], ' ' 
    jne check_compare ;if not space
    inc si
    
    cmp byte ptr[si], 13
    je the_end ;if end of string - to programm end
                      
    jmp first_word
     
loop_per_line:
    inc si
    cmp byte ptr[si], ' '
    je check_whitespace ;if space
    cmp byte ptr[si], 13 
    jne loop_per_line 
    cmp ax, 0
    jne main_loop
    jmp the_end ;if string end - end
       
check_compare:
    cmp dx, 0
    jne compare ;if two words - compare
    push si ;addres of first word in stack
    mov dx, 1 
    jmp loop_per_line
    
check_whitespace:
    cmp byte ptr[si+1], ' '
    je loop_per_line ;if few spaces - next
    inc si ;second word address
    jmp check_compare
    
compare:
    pop di ;take in es:di first word address    
    push si ;first and second words address to stack 
    push di    
    mov cx, si
    sub cx, di
    repe cmpsb ;compare while symbols are equal 
    dec si
    dec di
    xor bx, bx
    mov bl,byte ptr[di] 
    cmp bl, byte ptr[si] 
    jg change ; imagine if first word > second
    pop di
    pop si
    push si 
    
    jmp loop_per_line
    
change:
    inc al
    pop di
    pop si
    
    xor cx, cx
    xor bx, bx
    mov dx, si ;second word 
loop1: ;finding of second word start
    dec si
    inc cx
    cmp byte ptr [si-1], ' '
    je loop1
    
loop2:
    dec si
    mov bl, byte ptr [si] 
    push bx ;first word to the stack from the end
    inc ah ;size of first word
    cmp si, di
    jne loop2
    
    mov si, dx ;address of second word start
    
loop3:  ;second word on first
    cmp byte ptr [si], 13
    je loop4
    mov bl, byte ptr [si]
    xchg byte ptr [di], bl
    
    inc si
    inc di
    cmp  byte ptr [si], ' '
    jne loop3
    
loop4:
    mov byte ptr[di], ' '
    inc di
    loop loop4
    
    mov si, di
    mov dx, si
    dec si
loop5: ;first word on second from stack
    inc si
    cmp byte ptr[si], 13
    je main_loop
    
    pop bx
    mov byte ptr[si], bl
    
    dec ah
    cmp ah, 0
    je loop6
    
    jmp loop5
    
loop6:
    push dx
    mov dx, 1
    xor cx, cx
    jmp loop_per_line 
    
check_loop:   ;dlya perevoda taba v probel   
     cmp [si], 9
     je tab_to_space
     inc si  
     
     cmp [si], '$'
     jne check_loop
     jmp str
               
tab_to_space:
    mov [si], 32
    jmp check_loop
                   
error_end:   
    mov ax, 3
    int 10h
    output message_error
    jmp endend  
        
the_end:   
    output endline
    output message_output 
    
    mov ah, 9
    mov dx, offset line + 2
    int 21h
    
    mov ah, 4Ch
    int 21h
    jmp endend
    
endend:
 

CODE_SEG    ENDS
   END  start
