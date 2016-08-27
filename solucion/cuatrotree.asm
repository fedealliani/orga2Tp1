%define NULL 0
%define offset_arbol_root 0
%define offset_arbol_size 8
%define offset_nodo_father 0
%define offset_nodo_valorUno 8
%define offset_nodo_valorDos 12
%define offset_nodo_valorTres 16
%define offset_nodo_len 20
%define offset_nodo_hijo1 21
%define offset_nodo_hijo2 29
%define offset_nodo_hijo3 37
%define offset_nodo_hijo4 45
%define offset_iter_arbol 0
%define offset_iter_nodo 8
%define offset_iter_current 16
%define offset_iter_count 17


; FUNCIONES de C
  extern malloc
  extern free
  extern fprintf
  extern printf
   
; FUNCIONES
  global ct_new
  global ct_delete
  global ct_print
  global ctIter_new
  global ctIter_delete
  global ctIter_first
  global ctIter_next
  global ctIter_get
  global ctIter_valid
 

 section .data 

 printValor: DB '%d',10,0

section .text

; =====================================
; void ct_new(ctTree** pct);
ct_new:
;Recibo el parametro de C
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A

  mov r12,rdi ; Tengo en r12 el puntero al puntero que contiene donde comienza el struct
  mov rdi,12
  call malloc
  mov [r12],rax
  ;Creo un nodo root nulo
  mov r13,rax
  mov rdi,53
  call malloc
  mov r14,NULL
  mov [r13+offset_arbol_root],rax
  mov [r13+offset_arbol_size],r14d
  mov [rax+offset_nodo_father],r14
  mov[rax+offset_nodo_len],r14b
  mov[rax+offset_nodo_hijo1],r14
  mov[rax+offset_nodo_hijo2],r14
  mov[rax+offset_nodo_hijo3],r14
  mov[rax+offset_nodo_hijo4],r14


  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
    ret;A

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
;Recibo el parametro de C
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  
  mov r12,rdi ; Tengo en r12 la direccion que apunta al puntero que apunta al struct
  mov rdi,[r12]; Tengo el puntero al struct y al nodo root
  call ct_aux_delete­­
  mov rdi,[r12]
  call free
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
        ret ;A
        
; =====================================
; void ct_aux_delete(ctNode* node);
;Recibo el parametro de C
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A

  mov r12,rdi
  mov r13b,[r12+offset_nodo_len]
  cmp r13b,3
  jne eliminarseElMismo
  mov r13,[r12+offset_nodo_hijo1]
  cmp r13,NULL
  JE eliminarHijo2
  mov rdi,r13
  call ct_aux_delete
eliminarHijo2:
  mov r13,[r12+offset_nodo_hijo2]
  cmp r13,NULL
  JE eliminarHijo3
  mov rdi,r13
  call ct_aux_delete
eliminarHijo3:
  mov r13,[r12+offset_nodo_hijo3]
  cmp r13,NULL
  JE eliminarHijo4
  mov rdi,r13
  call ct_aux_delete
eliminarHijo4:
  mov r13,[r12+offset_nodo_hijo4]
  cmp r13,NULL
  JE eliminarElMismo
  mov rdi,r13
  call ct_aux_delete
eliminarElMismo:
  mov rdi,r12
  call free
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
  ret ;A

; ; =====================================
; ; void ct_aux_print(ctNode* node,FILE *pFile);
ct_aux_print:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  ;FIJARSE QUE NODE DISTINTO DE NULL
  mov rbx,rsi ; Tengo la direccion del file
  mov r12,rdi ; Tengo en r12 la direccion del nodo
  cmp r12,NULL
  je finPrint
  mov r13b,[r12+offset_nodo_len];r13b tiene el len del nodo
  cmp r13b,3; Comparo len del nodo con 3, si es igual hago recursion
  je recursion
  mov r14,0 ; r14 contador
  cicloPrintAux:
    cmp r14b,r13b    ;comparo len con contador
    je finPrint         ;si son iguales termine
    mov rdi,rbx     ; Pongo en rdi la direccion del file
    mov rsi,printValor ; pongo en rsi el string
    mov edx,[r12+r14*4+8] ; pongo en rdx el value
    call fprintf          ; llamo a fprintf
    add r14b,1            ; sumo uno al contador
    jmp cicloPrintAux             ; vuelvo al ciclo

recursion:
 mov rdi,[r12+offset_nodo_hijo1]; ; pongo en rdi el primer hijo
 mov rsi,rbx ;Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el primer hijo
  mov rdi,rbx     ; Pongo en rdi la direccion del file
  mov rsi,printValor ; pongo en rsi el string
  mov edx,[r12+offset_nodo_valorUno] ; pongo en rdx el value[0]
  call fprintf

  mov rdi,[r12+offset_nodo_hijo2]; ; pongo en rdi el primer hijo
 mov rsi,rbx ;Pongo en rsi la direccion del file
   call ct_aux_print ; hago recursion con el primer hijo
  mov rdi,rbx     ; Pongo en rdi la direccion del file
  mov rsi,printValor ; pongo en rsi el string
  mov edx,[r12+offset_nodo_valorDos] ; pongo en rdx el value[0]
  call fprintf

  mov rdi,[r12+offset_nodo_hijo3]; ; pongo en rdi el primer hijo
  mov rsi,rbx ;Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el primer hijo
  mov rdi,rbx     ; Pongo en rdi la direccion del file
  mov rsi,printValor ; pongo en rsi el string
  mov edx,[r12+offset_nodo_valorTres] ; pongo en rdx el value[0]
  call fprintf

  mov rdi,[r12+offset_nodo_hijo4]; ; pongo en rdi el primer hijo
  mov rsi,rbx ;Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el primer hijo


finPrint:
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
        ret ;A

; ; =====================================
; ; void ct_print(ctTree* ct,FILE *pFile);
ct_print:
push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r8,rdi
  mov rdi,[r8+offset_arbol_root]
  call ct_aux_print
   pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
        ret

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:
  mov r9,NULL
  mov r8,rdi ; Tengo en r8 la direccion del arbol.
  mov [r8+offset_iter_arbol],r8 ; Guardo la direccion del arbol
  mov [r8+offset_iter_nodo],r9 ; Pongo null en el nodo actual
  mov [r8+offset_iter_current],r9b ; Pongo 0 en el current
  mov [r8+offset_iter_count],r9d ; Pongo 0 en count
  mov rax,r8 ; Le retorno la direccion del iterador
  
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
  call free ; En RDI ya esta la direccion porque me la paso C. 
        ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  push rbx ;D
  push r12 ;A
  push r13 ;D
  push r14 ;A
  push r15 ;D
  mov r8,rdi ;En r8 tengo la direccion iterador
  mov r9,[r8+offset_iter_arbol] ; En r9 tengo la direccion del arbol
  mov r10,[r9+offset_arbol_root] ; En r10 tengo la direccion nodo root del arbol
  mov r12,r10
  mov r13,r10
  ciclo:
  ;r12 es el nodo temporal a preguntar
  ;r13 es el ultimo nodo que tiene valor
  ;if(nodo.hijo[0]!=null)
  mov r13,r12 ; Muevo la direccion del nodo a r13
  mov r12,[r13+offset_nodo_hijo1] ;Muevo la direccion del nodo hijo1 para ver si no es NULL
  cmp r12,NULL
  jnz ciclo ;Si no es null sigo en el ciclo
  ;Sali del ciclo y tengo en r13 el ultimo nodo valido
  mov [r8+offset_iter_nodo],r13
  mov r14b,1
  mov [r8+offset_iter_current],r14b
  mov r14d,0
  mov [r8+offset_iter_count],r14d
  pop r15;A
  pop r14;D
  pop r13;A
  pop r12;D
  pop rbx;A
  pop rbp;D
  ;ESTA DESALINEADA !!!
  ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
;;DESALINEADA
;  push rbp ;A
;  mov rbp,rsp
;  push rbx ;D
;  push r12 ;A
;  push r13 ;D
;  push r14 ;A
;  push r15 ;D
;
;  mov r8,rdi ;En r8 tengo la direccion del iterador
;  mov r9b,[r8+offset_iter_current]; En r9b tengo la direccion de  current
;  mov r10b,[r9b] ; En r10b tengo el valor de current
;  add r10b,1 ; current++
;  mov [r9b],r10b ; Guardo a current en su lugar
;  mov r11,[r8+offset_iter_nodo] ; En r11 tengo la direccion del nodo
;  mov r12,[r11+offset_nodo_hijo1+r10b] ; En r12 tengo al hijo del nodo [current]
;primerIf:
;  cmp r12,0
;  jnz segundoElse
;segundoIf:
;  mov r13b,[r11+offset_nodo_len]
;  sub r13b,1
;  cmp r10b,r13b
;  jle end
;  ;REALIZAR ESTA FUNCION
;  call ctIter_aux_up ; Ya tengo en RDI la direccion del iterador
;  jmp end


;segundoElse:
;  mov [r11],r12 ; Asigno un nuevo nodo en el iterador
;  ;REALIZAR ESTA FUNCION
;  call ctIter_aux_down ; Bajo hasta encontrar el menor del subarbol (RDI ya tiene la direccion del iterador)
;  jmp end
 ;RELEER EL ENUNCIADO QUE HAY UNA FUNCION QUE NO USE...
;end:
;  pop r15
;  pop r14
;  pop r13
;  pop r12
;  pop rbx
;  pop rbp
;  ret

 


; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
  mov r9,[rdi+offset_iter_nodo] ;En r9 tengo la direccion del nodo actual
  mov r10b,[rdi+offset_iter_current]; En r10 tengo la posicion actual dentro del nodo
  mov eax, [rdi+r10*4+8] ; Guardo el resultado en eax(32 bits bajos de rax)
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
  mov r9,NULL
  cmp [rdi+offset_iter_nodo],r9
  jz esInvalido
  mov eax,1 ; 
fin:
        ret
esInvalido:
  mov eax,r9d
  jmp fin



