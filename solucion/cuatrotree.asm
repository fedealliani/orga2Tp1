%define NULL 0
%define offset_arbol_root 0
%define offset_arbol_size 8
%define offset_nodo_father 0
%define offset_nodo_valorUno 8
%define offset_nodo_valorDos 12
%define offset_nodo_valorTres 16
%define offset_nodo_len 20
%define offset_nodo_hijo 21
%define offset_iter_arbol 0
%define offset_iter_nodo 8
%define offset_iter_current 16
%define offset_iter_count 17


; FUNCIONES de C
  extern malloc
  extern free
  extern fprintf
   
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
 
section .text

; =====================================
; void ct_new(ctTree** pct);
ct_new:
;Recibo el parametro de C
  mov r8,[rdi] ; Me llego por RDI ctTree** pct --> r8= Direccion del struct.
  ;Defino el arbol, es decir, le pongo el puntero NULL al root y cantida de hijos =0
  mov r9,NULL
  mov [r8+offset_arbol_root],r9 ; Pongo en los primeros 8 bytes la direccion del nodo root en null
  mov [r8+offset_arbol_size],r9d ; Cantidad de hijos =0
        ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
        ret

; ; =====================================
; ; void ct_aux_print(ctNode* node);
ct_aux_print:
        ret

; ; =====================================
; ; void ct_print(ctTree* ct);
ct_print:
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
  mov r8,rdi ;En r8 tengo la direccion iterador
  mov r9,[r8+offset_iter_arbol] ; En r9 tengo la direccion del arbol
  mov r10,[r9+offset_arbol_root] ; En r10 tengo la direccion nodo root del arbol
  ;!!!! TENGO QUE RECORRER DEL MAS CHICO AL MAS GRANDE? !!!!!

        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
;ALINEADA
  push rbp ;D
  mov rbp,rsp
  push rbx ;A
  push r12 ;D
  push r13 ;A
  push r14 ;D
  push r15 ;A

  mov r8,rdi ;En r8 tengo la direccion del iterador
  mov r9b,[r8+offset_iter_current]; En r9b tengo la direccion de  current
  mov r10b,[r9b] ; En r10b tengo el valor de current
  add r10b,1 ; current++
  mov [r9b],r10b ; Guardo a current en su lugar
  mov r11,[r8+offset_iter_nodo] ; En r11 tengo la direccion del nodo
  mov r12,[r11+offset_nodo_hijo+r10b] ; En r12 tengo al hijo del nodo [current]
primerIf:
  cmp r12,0
  jnz segundoElse
segundoIf:
  mov r13b,[r11+offset_nodo_len]
  sub r13b,1
  cmp r10b,r13b
  jle end
  ;REALIZAR ESTA FUNCION
  call ctIter_aux_up ; Ya tengo en RDI la direccion del iterador
  jmp end


segundoElse:
  mov [r11],r12 ; Asigno un nuevo nodo en el iterador
  ;REALIZAR ESTA FUNCION
  call ctIter_aux_down ; Bajo hasta encontrar el menor del subarbol (RDI ya tiene la direccion del iterador)
  jmp end
 ;RELEER EL ENUNCIADO QUE HAY UNA FUNCION QUE NO USE...
end:
  pop r15
  pop r14
  pop r13
  pop r12
  pop rbx
  pop rbp
  ret

 


; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
  mov r9,NULL
  cmp rdi,r9
  jz esInvalido
  mov rax,[rdi+offset_iter_count] ;!!!!!!!PREGUNTAR QUE HAY QUE DEVOLVER!!!!!
fin:
        ret
esInvalido:
  mov rax,r9
  jmp fin


