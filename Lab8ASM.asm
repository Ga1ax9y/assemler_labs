.model small

.stack 400h

.data

Node STRUC
        key     dw ?
        left    dw ?
        right   dw ?
        height  dw ?
Node ENDS   
        
.code
START:

PUBLIC _MAX, _TREE_HEIGHT, _BALANCE, _TORIGHT, _TOLEFT, _MINNODE, _INSERTNODE, _DELETENODE, _FREETREE, _SEARCHNODE
EXTRN _new_node:near, _free_node:near


_MAX PROC
        push bp
        mov bp, sp
        
        mov ax, [bp + 4]
        mov bx, [bp + 6]
        cmp ax, bx
        jge loop1
        mov ax, bx
    loop1:
        pop bp
        ret
_MAX ENDP
        


_TREE_HEIGHT PROC
        push bp
        mov bp, sp
        push si
        
        mov si, [bp + 4]
        mov ax, 0
        cmp si, 0
        je  loop2
        mov ax, [si.height]
    loop2:
        pop si
        pop bp
        ret
_TREE_HEIGHT ENDP



_BALANCE PROC
        push bp
        mov bp, sp
        push si
        push di
        
        mov si, [bp + 4]
        mov ax, 0
        cmp si, 0
        je  loop3
        mov di, [si.left]
        push di
        call _TREE_HEIGHT
        add sp, 2
        mov cx, ax
        mov si, [bp + 4]
        mov di, [si.right]
        push di
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        sub cx, bx
        mov ax, cx
    loop3:
        pop di
        pop si
        pop bp
        ret
_BALANCE ENDP



_TORIGHT PROC
        push bp
        mov bp, sp
        sub sp, 4
        push si
        push di
        
        mov si, [bp + 4]
        mov di, [si.left]
        mov [bp - 2], di        
        
        mov si, [di.right]
        mov [bp - 4], si       
        
        mov si, [bp + 4]
        mov [di.right], si
        
        mov di, [bp - 4]
        mov [si.left], di
        
        mov ax, [si.left]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        mov si, [bp + 4]
        mov ax, [si.right]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        push bx
        push ax
        call _MAX
        add sp, 4
        inc ax
        mov si, [bp + 4]
        mov [si.height], ax
        
        mov si, [bp - 2]
        mov ax, [si.left]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        mov si, [bp - 2]
        mov ax, [si.right]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        push bx
        push ax
        call _MAX
        add sp, 4
        inc ax
        mov si, [bp - 2]
        mov [si.height], ax
        
        mov ax, [bp - 2]
        
        pop di
        pop si
        mov sp, bp
        pop bp
        ret
_TORIGHT ENDP        



_TOLEFT PROC
        push bp
        mov bp, sp
        sub sp, 4
        push si
        push di
        
        mov si, [bp + 4]
        mov di, [si.right]
        mov [bp - 2], di        
        
        mov si, [di.left]
        mov [bp - 4], si        
        
        mov si, [bp + 4]
        mov [di.left], si
        
        mov di, [bp - 4]
        mov [si.right], di
        
        mov ax, [si.left]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        mov si, [bp + 4]
        mov ax, [si.right]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        push bx
        push ax
        call _MAX
        add sp, 4
        inc ax
        mov si, [bp + 4]
        mov [si.height], ax
        
        mov si, [bp - 2]
        mov ax, [si.left]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        mov si, [bp - 2]
        mov ax, [si.right]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        push bx
        push ax
        call _MAX
        add sp, 4
        inc ax
        mov si, [bp - 2]
        mov [si.height], ax
        
        mov ax, [bp - 2]
        
        pop di
        pop si
        mov sp, bp
        pop bp
        ret
_TOLEFT ENDP



_MINNODE PROC
        push bp
        mov bp, sp
        push si
        push di
        
        mov si, [bp + 4]
loop4:        
        mov ax, si
        mov di, WORD PTR [si.left]
        mov si, di
        cmp si, 0
        jne loop4 
        
        pop di
        pop si
        pop bp
        ret
_MINNODE ENDP



_INSERTNODE PROC
        push bp
        mov bp, sp
        sub sp, 2
        push si
        push di
        
        mov si, [bp + 4]
        cmp si, 0
        jne loop5
        mov ax, [bp + 6]
        push ax
        call _new_node
        add sp, 2
        jmp loop6
loop5:
        mov ax, [bp + 6]
        mov bx, [si.key]
        cmp ax, bx
        jge  loop7
        mov di, [si.left]
        push ax
        push di
        call _INSERTNODE
        add sp, 4
        mov [si.left], ax
        jmp loop8
loop7:
        cmp ax, bx
        jle loop9
        mov di, [si.right]
        push ax
        push di
        call _INSERTNODE
        add sp, 4
        mov [si.right], ax
        jmp loop8
loop9:
        mov ax, [bp + 4]
        jmp loop6
loop8:
        mov si, [bp + 4]
        mov ax, [si.left]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        mov ax, [si.right]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        push bx
        push ax
        call _MAX
        add sp, 4
        inc ax
        mov [si.height], ax
        
        push si
        call _BALANCE
        add sp, 2
        mov [bp - 2], ax
        mov di, ax
        
        cmp di, 1
        jle loop10
        mov si, [si.left]
        mov bx, [si.key]
        mov ax, [bp + 6]
        cmp ax, bx
        jge loop11
        mov si, [bp + 4]
        push si
        call _TORIGHT
        add sp, 2
        jmp loop6
loop11:
        cmp ax, bx
        jle loop10
        push si
        call _TOLEFT
        add sp, 2
        mov si, [bp + 4]
        mov [si.left], ax
        push si
        call _TORIGHT
        add sp, 2
        jmp loop6
loop10:
        cmp di, -1
        jge loop12
        mov si, [si.right]
        mov bx, [si.key]
        mov ax, [bp + 6]
        cmp ax, bx
        jle loop13
        mov si, [bp + 4]
        push si
        call _TOLEFT
        add sp, 2
        jmp loop6
loop13:
        cmp ax, bx
        jge loop12
        push si
        call _TORIGHT
        add sp, 2
        mov si, [bp + 4]
        mov [si.right], ax
        push si
        call _TOLEFT
        add sp, 2
        jmp loop6
loop12:
        mov ax, [bp + 4]
loop6:        
        pop di
        pop si
        mov sp, bp
        pop bp
        ret
_INSERTNODE ENDP




_DELETENODE PROC
        push bp
        mov bp, sp
        push si
        push di
        
        mov si, [bp + 4]
        cmp si, 0
        jne loop132
        mov ax, si
        jmp loop14
loop132:
        mov ax, [bp + 6]
        mov bx, [si.key]
        cmp ax, bx
        jge loop15
        mov di, [si.left]
        push ax
        push di
        call _DELETENODE
        add sp, 4
        mov [si.left], ax
        jmp loop16
loop15:
        cmp ax, bx
        jle loop17
        mov di, [si.right]
        push ax
        push di
        call _DELETENODE
        add sp, 4
        mov [si.right], ax
        jmp loop16
loop17:
        mov ax, [si.left]
        mov bx, [si.right]
        cmp ax, 0
        je  loop18
        cmp bx, 0
        jne loop19
loop18:
        cmp ax, 0
        jne loop20
        mov ax, bx
loop20:
        mov di, ax
        cmp di, 0
        jne loop21
        mov di, si
        mov si, 0
        jmp loop22
loop21:
        mov ax, [di.key]
        mov [si.key], ax
        mov ax, [di.left]
        mov [si.left], ax
        mov ax, [di.right]
        mov [si.right], ax
        mov ax, [di.height]
        mov [si.height], ax
loop22:
        push di
        call _free_node
        add sp, 2
        jmp loop16
loop19:
        mov ax, [si.right]
        push ax
        call _MINNODE
        add sp, 2
        mov di, ax
        mov ax, [di.key]
        mov [si.key], ax
        push ax
        mov bx, [si.right]
        push bx
        call _DELETENODE
        add sp, 4
        mov [si.right], ax
        
loop16:
       cmp si, 0
       jne loop23
       mov ax, si 
       jmp loop14
       
loop23:
        mov ax, [si.left]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        mov bx, ax
        mov ax, [si.right]
        push ax
        call _TREE_HEIGHT
        add sp, 2
        push bx
        push ax
        call _MAX
        add sp, 4
        inc ax
        mov [si.height], ax
        
        push si
        call _BALANCE
        add sp, 2
        mov di, ax
        
        cmp di, 1
        jle loop24
        mov bx, [si.left]
        push bx
        call _BALANCE
        add sp, 2
        cmp ax, 0
        jl  loop25
        push si
        call _TORIGHT
        add sp, 2
        jmp loop14
loop25:
        mov ax, [si.left]
        push ax
        call _TOLEFT
        add sp, 2
        mov [si.left], ax
        push si
        call _TORIGHT
        add sp, 2
        jmp loop14
loop24:
        cmp di, -1
        jge loop26
        mov bx, [si.right]
        push bx
        call _BALANCE
        add sp, 2
        cmp ax, 0
        jg  loop27
        push si
        call _TOLEFT
        add sp, 2
        jmp loop14
loop27:
        mov ax, [si.right]
        push ax
        call _TORIGHT
        add sp, 2
        mov [si.right], ax
        push si
        call _TOLEFT
        add sp, 2
        jmp loop14      
loop26:
        mov ax, si      
loop14:        
        pop di
        pop si
        mov sp, bp
        pop bp
        ret
_DELETENODE ENDP



_FREETREE PROC
        push bp
        mov bp, sp
        push si
        push di
        
        mov si, [bp + 4]
        cmp si, 0
        je loop28
        
        mov ax, [si.left]
        push ax
        call _FREETREE
        add sp, 2
        mov ax, [si.right]
        push ax
        call _FREETREE
        add sp, 2
        
        push si
        call _FREETREE
        add sp, 2

loop28:        
        pop di
        pop si
        mov sp, bp
        pop bp
        ret
_FREETREE ENDP



_SEARCHNODE PROC
        push bp
        mov bp, sp
        push si
        push di
        
        mov si, [bp + 4]
        cmp si, 0
        jne loop29
        mov ax, si
        jmp loop30
loop29:
        mov ax, [bp + 6]
        mov bx, [si.key]
        cmp ax, bx
        jge loop31
        mov cx, [si.left]
        push ax
        push cx
        call _SEARCHNODE
        add sp, 4
        jmp loop30
loop31:
        cmp ax, bx
        jle loop32
        mov cx, [si.right]
        push ax
        push cx
        call _SEARCHNODE
        add sp, 4
        jmp loop30
loop32:
        mov ax, si        
loop30:
        pop di
        pop si
        mov sp, bp
        pop bp
        ret
_SEARCHNODE ENDP


        END START
        
        
      