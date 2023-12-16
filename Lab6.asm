.model small
.data

maxWordSize           equ 1600
buffer db 1h dup(?)
bf db 200 dup(0h)
start_text db "The program is started", 0Ah, 0Dh, "$" 
end_text db "The program is ended", 0Ah, 0Dh, "$"
file_name db 15 dup('$')
noDataText db "No data in command line", 0Ah, 0Dh, "$"
num_str db 50 dup(0)
n dw ?
current dw 0
;N dw ?
ten db 10
error_open_file db "error", 0Ah, 0Dh, "$"
error_close_file db "wrong identificator", 0Ah, 0Dh, "$"
index dw 0
temp_filename db 'tempo.txt', 0
file_handle1 dw ?
file_handle2 dw ?
new_handle_in dw ?
error_num db 1
.code

getComArgs proc
    mov di, 80h
    mov cl, es:[di]
    cmp cl, 1h
    jle empty_cmd
    mov cx,-1h          
    mov di,81h
    mov al,' '
    repe scasb
    dec di         
    mov bx,0h
get_file_name:
    cmp es:[di],0Dh
    je set_string_end
    cmp es:[di],' '
    je set_string_end2
    mov al,es:[di]
    mov file_name[bx],al
    inc bx    
    inc di
    jmp get_file_name    
set_string_end:
    mov file_name[bx], 0h
    ret
set_string_end2:
    mov file_name[bx],0h
    mov bx,2
    jmp get_num
set_string_end3:
    mov b.num_str[bx],13
    ret
get_num:
    cmp es:[di],' ' 
    je skip_space
    cmp es:[di],0Dh
    je set_string_end3
    mov al,es:[di]
    mov b.num_str[bx],al
    mov error_num,0
    inc bx
    inc di
    jmp get_num
skip_space:
    cmp error_num,0
    je errornum
    mov b.num_str[1],2
    inc di
    jmp get_num                         
empty_cmd:
    lea dx, noDataText
    mov ah, 09h
    int 21h
    mov ax,4C00h
    int 21h             
getComArgs endp
parseToNumBegin:
    mov bx,2
    xor ax,ax
    xor cx,cx
parseToNum:
    cmp num_str[bx] ,13
    je errornum
    
    mov al,num_str[bx]
    sub al,'0'
    inc bx
    cmp num_str[bx],13
    je parseToNumEnd
    mul ten
    add cx,ax
    jmp parseToNum
parseToNumEnd:
   
    add cx,ax
    mov n,cx            
    jmp next_step
errornum:
    jmp exit

start:
    mov ax,@data
    mov ds,ax
    call getComArgs
    jmp parseToNumBegin
next_step:    
    mov ah,3Dh
    mov al,0h
    lea dx,file_name
    int 21h
    jc print_open_error
    mov bx, ax
    mov file_handle1, ax
    mov ah, 3Ch         
    mov cx, 0           
    lea dx, temp_filename   
    int 21h             
    mov ah, 3Dh
    mov al, 1h
    lea dx, temp_filename
    int 21h     
    jc print_open_error
    mov file_handle2, ax
    
    
    
    lea dx, start_text
    mov ah, 09h
    int 21h

    mov current, 1
    xor ax, ax 
read_loop:
    mov ah, 3Fh         
    mov cx, 1 
    lea dx, buffer
    mov bx, file_handle1     
    int 21h
    cmp ax, 0            
    je end_of_file
      	
	mov al, buffer
	mov bp,n		
	cmp current, bp
    je skip_line
	              
	   
	   


	
	mov ah, 40h
	mov bx, file_handle2        
    mov cx, 1  
    lea dx, [buffer]    
    int 21h
    
    mov al, buffer 
    cmp al, 10
    je increm
    jmp read_loop
    
increm:
    inc current
    jmp read_loop    
                 
skip_line:
  ;  mov current, 1
    cmp al, 10
    je skip
    jmp read_loop
skip:
    mov current, 1
    jmp read_loop    
     
end_of_file:   
    mov ah, 3Eh        
    mov bx, file_handle1           
    int 21h              
    jc print_open_error
    mov ah, 3Eh        
    mov bx, file_handle2          
    int 21h             
    jc print_open_error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    mov ah, 3Ch
    lea dx,file_name
    mov cx,0
    int 21h
    
    mov new_handle_in, ax
    mov ah,3Eh
    mov bx, new_handle_in
    int 21h
    cmp ax,06h
    je print_close_error
    mov ah,3Dh
    lea dx,file_name
    mov al,1
    int 21h
    
    mov ah,3Dh
    lea dx, temp_filename
    mov al,0
    int 21h
read:
    mov ah, 3Fh
    mov bx, file_handle2
    lea dx, buffer
    mov cx, 1
    int 21h

    cmp ax, 0
    je end_of_filee        
    mov ah, 40h           
    mov bx, new_handle_in 
    lea dx, buffer
    mov cx, 1             
    int 21h        
jmp read
     
end_of_filee:
    mov ah, 3Eh    
    mov bx, file_handle2
    int 21h
       
    mov ah, 3Eh     
    mov bx, new_handle_in
    int 21h
        
    xor dx, dx
    mov ah, 41h
    lea dx, temp_filename
    int 21h
           
jmp exit    
                  
exit:
    lea dx, end_text
    mov ah, 09h
    int 21h
    
    mov ah, 4Ch        
    int 21h
print_open_error:
    lea dx, error_open_file
    mov ah, 09h
    int 21h
    jmp exit
print_close_error:
    lea dx, error_open_file
    mov ah, 09h
    int 21h
    jmp exit    
end start
             



    