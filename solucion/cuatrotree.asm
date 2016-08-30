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
;void ct_aux_delete(ctNode* node);
;DESALINEADA
auxDelete:
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
  call auxDelete
eliminarHijo2:
  mov r13,[r12+offset_nodo_hijo2]
  cmp r13,NULL
  JE eliminarHijo3
  mov rdi,r13
  call auxDelete
eliminarHijo3:
  mov r13,[r12+offset_nodo_hijo3]
  cmp r13,NULL
  JE eliminarHijo4
  mov rdi,r13
  call auxDelete
eliminarHijo4:
  mov r13,[r12+offset_nodo_hijo4]
  cmp r13,NULL
  JE eliminarseElMismo
  mov rdi,r13
  call auxDelete
eliminarseElMismo:
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



; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r12,rdi ;r12 la direccion que apunta al puntero que apunta al struct
  mov r13,[r12];En r13 tengo el puntero al struct
  mov rdi,[r13+offset_arbol_root] ; puntero al nodo root 

  call auxDelete
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

  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r12,NULL
  mov r13,rdi ; Tengo en r13 la direccion del arbol
  mov rdi,21
  call malloc
  mov r14,rax ; Tengo el puntero al iterador
  mov [r14+offset_iter_arbol],r13 ; Guardo la direccion del arbol
  mov [r14+offset_iter_nodo],r12 ; Pongo null en el nodo actual
  mov [r14+offset_iter_current],r12b ; Pongo 0 en el current
  mov [r14+offset_iter_count],r12d ; Pongo 0 en count  
   pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
  call free ; En RDI ya esta la direccion porque me la paso C. 
        ret


; =====================================
; ctNode* nodoMasALaIzq(ctNode* node);

nodoMasALaIzq:
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r12,rdi ; Tengo en r12 el puntero al nodo actual
  mov r13,rdi; Tengo en r13 el puntero al nodo actual
ciclo:
  ;r12 es el nodo temporal a preguntar
  ;r13 es el ultimo nodo que tiene valor
  ;if(nodo.hijo[0]!=null)
  mov r13,r12 ; Muevo la direccion del nodo a r13
  mov r12,[r13+offset_nodo_hijo1] ;Muevo la direccion del nodo hijo1 para ver si no es NULL
  cmp r12,NULL
  jnz ciclo ;Si no es null sigo en el ciclo
  ;Sali del ciclo y tengo en r13 el ultimo nodo valido
  mov rax,r13
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
  ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r12,rdi ;En r12 tengo la direccion iterador
  mov r13,[r12+offset_iter_arbol] ; En r13 tengo la direccion del arbol
  mov r14,[r13+offset_arbol_root] ; En r14 tengo la direccion nodo root del arbol
  mov rdi,r14
  call nodoMasALaIzq
  mov r13,rax
  mov [r12+offset_iter_nodo],r13
  mov r14b,0
  mov [r12+offset_iter_current],r14b
  mov r14d,1
  mov [r12+offset_iter_count],r14d
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
  ret


; =====================================
; uint32_t ctIter_aux_up(ctNode* current,ctNode* father);
ctIter_aux_up:
  push rbp
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A

  mov r12,rdi ; R12 PUNTERO A CURRENT 
  mov r13,rsi ; R13 PUNTERO A FATHER
  
  mov r14,[rsi+offset_nodo_hijo1]
  cmp r14,r12
  je esHijoPrimero
  
  mov r14,[rsi+offset_nodo_hijo2]
  cmp r14,r12
  je esHijoSegundo
  
  mov r14,[rsi+offset_nodo_hijo3]
  cmp r14,r12
  je esHijoTercero
  
  mov eax,3
  jmp finAuxUp
  

  esHijoPrimero:
    mov eax,0
    jmp finAuxUp
  esHijoSegundo:
    mov eax,1
    jmp finAuxUp
  esHijoTercero:
   mov eax,2
   jmp finAuxUp
finAuxUp:
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
  ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
  push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A

  mov r12,rdi; Tengo en r12 el puntero al iterador
  mov r13,1
  add [r12+offset_iter_current],r13b ; AUMENTO CURRENT
  add [r12+offset_iter_count],r13d ; AUMENTO COUNT
  mov r13d,[r12+offset_iter_count]
  mov r14,[r12+offset_iter_arbol]
  mov r15d,[r14+offset_arbol_size]
  cmp r13d,r15d
  jg terminoIterador
  mov r13,NULL
  mov r13b,[r12+offset_iter_current] ;Tengo en r13 current actual
  mov r14,[r12+offset_iter_nodo]
  mov r15,[r14+r13*8+21]
  cmp r15,NULL
  jne hayHijos
  mov r14,[r12+offset_iter_nodo]
  mov r15,NULL
  mov r15b,[r14+offset_nodo_len]
  sub r15b,1
  cmp r15b,r13b
  jge salirIterNext
suboLevel:
  mov rdi,[r12+offset_iter_nodo]
  mov rsi,[rdi+offset_nodo_father]
  call ctIter_aux_up
  mov r13,[r12+offset_iter_nodo]
  mov r14,[r13+offset_nodo_father]
  mov [r12+offset_iter_nodo],r14 ; PONGO AL ITERADOR EN EL NODO PADRE
  mov [r12+offset_iter_current],al ; PONGO EN EL CURRENT CORRESPONDIENTE
  cmp al,3
  je suboLevel
  jmp salirIterNext

  ;TERMINO EL ITERADOR!
  terminoIterador:
  mov r13,NULL
  mov [r12+offset_iter_nodo],r13
  jmp salirIterNext
  hayHijos:
  mov r14,[r12+offset_iter_nodo]
  mov rbx,0
  mov bl,[r12+offset_iter_current]
  mov r15,[r14+rbx*8+21] ; R15 ES CHILD[CURRENT]
  mov rdi,r15
  call nodoMasALaIzq
  mov [r12+offset_iter_nodo],rax ; Pongo en el iterador el nodo mas a la izq
  mov r13,NULL
  mov [r12+offset_iter_current],r13b; PONGO CURRENT EN 0
salirIterNext:
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
  ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r12,rdi ; En r12 tengo el puntero al iterador
  mov r13,[r12+offset_iter_nodo] ;En r13 tengo la direccion del nodo actual
  mov r10,NULL
  mov r10b,[r12+offset_iter_current]; En r10 tengo la posicion actual dentro del nodo
  mov rax,NULL
  mov eax, [r13+r10*4+8] ; Guardo el resultado en eax(32 bits bajos de rax)
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D

        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:

 push rbp ;A
  mov rbp,rsp
  sub rsp,8;D
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A
  mov r12,NULL
  mov r13,rdi;En r13 tengo el puntero al iterador
  cmp [r13+offset_iter_nodo],r12
  jz esInvalido
  mov eax,1 ; 
fin:
  pop r15;D
  pop r14;A
  pop r13;D
  pop r12;A
  pop rbx;D
  add rsp,8;A
  pop rbp;D
        ret
esInvalido:
  mov eax,r12d
  jmp fin



