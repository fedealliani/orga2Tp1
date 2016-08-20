%define NULL 0
%define offset_arbol_root 0
%define offset_arbol_size 8
%define offset_nodo_father 0
%define offset_nodo_valorUno 8
%define offset_nodo_valorDos 12
%define offset_nodo_valorTres 16
%define offset_nodo_len 20
%define offset_nodo_hijo 21


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
  ;Libero memoria para el nodo root
  mov rdi,29 ; Muevo a rd1 29 , porque voy a liberar 29 bytes para el nodo root
  call malloc ; Libero 12 bytes y me devuelve la direccion en RAX =Direccion comienzo nodo root struct
  ;Defino el arbol, es decir, le pongo el puntero al root y cantida de hijos =0
  mov [r8+offset_arbol_root],rax ; Pongo en los primeros 8 bytes la direccion del nodo root
  mov r9,0
  mov [r8+offset_arbol_size],r9 ; Cantidad de hijos =0
; Ahora pongo el nodo root todo en null
  mov r9,r8
  mov r8,[r9];Tengo en r8 la direccion de inicio del nodo root
  mov r9,NULL
  mov  [r8+offset_nodo_father],r9 ; Nodo padre = null
  mov [r8+offset_nodo_valorUno],r9d; Si no tiene hijos va 0 ??
  mov  [r8+offset_nodo_valorDos],r9d; Si no tiene hijos va 0 ??
  mov [r8+offset_nodo_valorTres],r9d; Si no tiene hijos va 0 ??
  mov  [r8+offset_nodo_len],r9b; CAMBIAR EL MOV PARA QUE SEA UN BYTES 
  mov  [r8+offset_nodo_hijo],r9; 
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
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
        ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
        ret



