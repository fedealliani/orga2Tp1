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
%define treeSize 12
%define nodoSize 53
%define iterSize 21


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

;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  push r12;D
  sub rsp,8;A
;Recibo el parametro de C

  mov r12,rdi ; Tengo en r12 el puntero al puntero que contiene donde comienza el struct
  mov rdi,treeSize ; Pongo en rdi el size del tree para llamar a malloc
  call malloc
  mov [r12],rax   ; Guardo la direccion que me asigno malloc en lo que apunta pct

  ;Creo un nodo root nulo
  mov r9,rax  ; Guardo en R9 es la direccion del tree
  mov rdi,nodoSize  ; Pongo en rdi el size del nodo para llamar a malloc
  call malloc

  ;Asigno las variables del tree
  mov r10,NULL      ; Pongo en r10 NULL
  mov [r9+offset_arbol_root],rax ; El nodo root es el que libere recien con malloc
  mov [r9+offset_arbol_size],r10d ; El size del arbol es 0

  ;Asigno los valores del nodo root vacio
  mov [rax+offset_nodo_father],r10 ; El father del nodo root es NULL
  mov[rax+offset_nodo_len],r10b ; Len del nodo =0
  mov[rax+offset_nodo_hijo1],r10 ; hijo1=null
  mov[rax+offset_nodo_hijo2],r10 ; hijo2=nul
  mov[rax+offset_nodo_hijo3],r10 ; hijo3=nul
  mov[rax+offset_nodo_hijo4],r10 ; hijo4=nul

  add rsp,8;D
  pop r12;A
  pop rbp;D
  ret;A



; =====================================
;void ct_aux_delete(ctNode* node);
;DESALINEADA
auxDelete:
  push rbp ;A
  mov rbp,rsp
  push r12 ;D
  push r13 ;A

;Recibo el parametro 
  mov r12,rdi ; Tengo en r12 el puntero al nodo
  mov r13,NULL
  mov r13b,[r12+offset_nodo_len] ; Tengo en r13 el len del nodo
  cmp r13b,3 ; comparo el len del nodo con 3
  ;Si el len del nodo es menor a 3 entonces no tiene hijos y ya lo puedo eliminar
  jne eliminarseElMismo

;Tiene hijos, me fijo cuales hijos tiene y llamo recursivamente para eliminar a los hijos
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

  ;Elimino al nodo que me pasaron por parametro, ya que elimine a todos sus hijos o no tenia hijos para eliminar.
eliminarseElMismo:
  mov rdi,r12
  call free

  pop r13;D
  pop r12;A
  pop rbp;D
  ret ;A



; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  push r12;D
  sub rsp,8;A

  mov r12,rdi ;En r12 la direccion que apunta al puntero que apunta al struct
  mov r9,[r12];En r9 tengo el puntero al struct
  mov rdi,[r9+offset_arbol_root] ; En rdi tengo el puntero al nodo root 

;Llamo a la funcion que va a eliminar recursivamente todos los nodos
  call auxDelete 

  mov rdi,[r12] ; Muevo a rdi la direccion del arbol
  call free

  add rsp,8;D
  pop r12;A
  pop rbp;D
  ret ;A
        

; ; =====================================
; ; void ct_aux_print(ctNode* node,FILE *pFile);
ct_aux_print:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  push rbx ;D
  push r12 ;A
  push r13 ;D
  push r14 ;A


  mov rbx,rsi ; Tengo la direccion del file
  mov r12,rdi ; Tengo en r12 la direccion del nodo
  cmp r12,NULL ;Si r12 es null entonces no tengo nada que imprimir
  je finPrint
  mov r13,NULL
  mov r13b,[r12+offset_nodo_len]   ;  r13b tiene el len del nodo
  cmp r13b,3; Comparo len del nodo con 3, si es igual hago recursion, si no imprimo los valores
  je recursion
  mov r14,0 ; r14 contador
  cicloPrintAux:
    cmp r14b,r13b    ;comparo len con contador
    je finPrint         ;si son iguales termine
    mov rdi,rbx     ; Pongo en rdi la direccion del file
    mov rsi,printValor ; pongo en rsi el string
    mov edx,[r12+r14*4+8] ; pongo en rdx el value (R12=direccion del nodo,R14=contador, multiplico por 4 porque cada valor ocupa 4bytes,le sumo 8 porque el primer valor esta en [r12+8])
    call fprintf          ; llamo a fprintf
    add r14b,1            ; sumo uno al contador
    jmp cicloPrintAux             ; vuelvo al ciclo


recursion:
  mov rdi,[r12+offset_nodo_hijo1]; ; pongo en rdi el primer hijo
  mov rsi,rbx ; Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el primer hijo
  mov rdi,rbx     ; Pongo en rdi la direccion del file
  mov rsi,printValor ; pongo en rsi el string
  mov edx,[r12+offset_nodo_valorUno] ; pongo en rdx el value[0]
  call fprintf

  mov rdi,[r12+offset_nodo_hijo2]; ; pongo en rdi el segundo hijo
  mov rsi,rbx ;Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el segundo hijo
  mov rdi,rbx     ; Pongo en rdi la direccion del file
  mov rsi,printValor ; pongo en rsi el string
  mov edx,[r12+offset_nodo_valorDos] ; pongo en rdx el value[1]
  call fprintf

  mov rdi,[r12+offset_nodo_hijo3]; ; pongo en rdi el tercer hijo
  mov rsi,rbx ;Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el tercer hijo
  mov rdi,rbx     ; Pongo en rdi la direccion del file
  mov rsi,printValor ; pongo en rsi el string
  mov edx,[r12+offset_nodo_valorTres] ; pongo en rdx el value[2]
  call fprintf

  mov rdi,[r12+offset_nodo_hijo4]; ; pongo en rdi el cuarto hijo
  mov rsi,rbx ;Pongo en rsi la direccion del file
  call ct_aux_print ; hago recursion con el cuarto hijo


finPrint:
  pop r14;D
  pop r13;A
  pop r12;D
  pop rbx;A
  pop rbp;D
  ret ;A

; ; =====================================
; ; void ct_print(ctTree* ct,FILE *pFile);
ct_print:
  push rbp ;A
  mov rbp,rsp

  mov r8,rdi ;En r8 tengo el puntero al arbol
  mov rdi,[r8+offset_arbol_root] ; Pongo en rdi el puntero al nodo root
  call ct_aux_print ; Imprimo recursivamente de menor a mayor (En RSI ya tengo el puntero al file)

  pop rbp;D
  ret ; A

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:

  push rbp ;A
  mov rbp,rsp
  push r13 ;D
  sub rsp,8;A
  
  mov r13,rdi ; Tengo en r13 la direccion del arbol
  mov rdi,iterSize ;Pongo en rdi el size del iterador para pedirlo con malloc
  call malloc

  mov r8,NULL
  mov r9,rax ; En r9 tengo la direccion del iterador recien liberado por malloc
  mov [r9+offset_iter_arbol],r13 ; Guardo la direccion del arbol
  mov [r9+offset_iter_nodo],r8 ; Pongo null en el nodo actual
  mov [r9+offset_iter_current],r8b ; Pongo 0 en el current
  mov [r9+offset_iter_count],r8d ; Pongo 0 en count  

  add rsp,8;D
  pop r13;A
  pop rbp;D
  ret ;A

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
;Desalineada
  push rbp ;A
  mov rbp,rsp

  call free ; En RDI ya esta la direccion porque me la paso C. 

  pop rbp;D
  ret ;A


; =====================================
; ctNode* nodoMasALaIzq(ctNode* node);
nodoMasALaIzq:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp

  mov r8,rdi ; Tengo en r8 el puntero al nodo actual
  mov r9,rdi; Tengo en r9 el puntero al nodo actual
ciclo:
  ;r8 es el nodo temporal a preguntar
  ;r9 es el ultimo nodo que tiene valor
  ;if(nodo.hijo[0]!=null)
  mov r9,r8 ; Muevo la direccion del nodo a r9
  mov r8,[r9+offset_nodo_hijo1] ;Muevo la direccion del nodo hijo1 para ver si no es NULL
  cmp r8,NULL
  jnz ciclo ;Si no es null sigo en el ciclo
  ;Sali del ciclo y tengo en r9 el ultimo nodo valido
  mov rax,r9

  pop rbp;D
  ret;A

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
;DESALINEADA
  push rbp ;A
  mov rbp,rsp
  push r12 ;D
  sub rsp,8;A

  mov r12,rdi ;En r12 tengo la direccion iterador
  mov r9,[r12+offset_iter_arbol] ; En r9 tengo la direccion del arbol
  mov rdi,[r9+offset_arbol_root] ; En rdi tengo la direccion nodo root del arbol
  call nodoMasALaIzq
  mov r9,rax
  mov [r12+offset_iter_nodo],r9
  mov r8,NULL
  mov [r12+offset_iter_current],r8b
  mov r8,1
  mov [r12+offset_iter_count],r8d

  add rsp,8;D
  pop r12;A
  pop rbp;D
  ret;A


; =====================================
; uint32_t ctIter_aux_up(ctNode* current,ctNode* father);
ctIter_aux_up:
;DESALINEADA
  push rbp;A
  mov rbp,rsp


  mov r8,rdi ; r8 PUNTERO A CURRENT 
  mov r9,rsi ; r9 PUNTERO A FATHER
  mov rax,NULL 

  ;Me fijo si es el hijo[0]
  mov r10,[r9+offset_nodo_hijo1] 
  cmp r10,r8
  je esHijoPrimero
  

    ;Me fijo si es el hijo[1]
  mov r10,[r9+offset_nodo_hijo2]
  cmp r10,r8
  je esHijoSegundo
  

      ;Me fijo si es el hijo[2]
  mov r10,[r9+offset_nodo_hijo3]
  cmp r10,r8
  je esHijoTercero
  
  ;Si llegue aca --> Es el 4to hijo==hijo[3]
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
  pop rbp;D
  ret;A

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

  mov r8,rdi ; En r8 tengo el puntero al iterador
  mov r9,[r8+offset_iter_nodo] ;En r9 tengo la direccion del nodo actual
  mov r10,NULL
  mov r10b,[r8+offset_iter_current]; En r10 tengo la posicion actual dentro del nodo
  mov rax,NULL
  mov eax, [r9+r10*4+8] ; Guardo el resultado en eax(32 bits bajos de rax)


  pop rbp;D

  ret;A

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:

  push rbp ;A
  mov rbp,rsp
  

  mov rax,NULL
  mov r8,NULL
  mov r9,rdi;En r9 tengo el puntero al iterador
  cmp [r9+offset_iter_nodo],r8 
  jz fin ; Si da null, el iterador es invalido (eax ya es 0)
  mov eax,1 ; Si no es null entonces es valido 

fin:
  pop rbp;D
        ret




