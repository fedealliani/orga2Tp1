#include "cuatrotree.h"



ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
//PRIMER CASO: NO EXISTE NODO DONDE METERLO
	if(*currNode==NULL){

		ctNode* nuevo= malloc(53);			//CREO EL NODO
		(*nuevo).father=fatherNode;			//LE ASIGNO SU PADRE
		(*nuevo).len=0;						//LE ASIGNO LEN 0
		for (int i = 0; i < 4; i++)	{
			(*nuevo).child[i]=NULL;
		}
											//PONGO TODOS LOS HIJOS EN NULL
if (fatherNode==NULL){
	return nuevo;
}
//ME FIJO DE QUE HIJO DEL PADRE VINO ASI LE ASIGNO ESTE NUEVO NODO
		if (newVal<(*fatherNode).value[0]){
			(*fatherNode).child[0]=nuevo;
		}else 
		if (newVal>(*fatherNode).value[0] && newVal<(*fatherNode).value[1]){
				(*fatherNode).child[1]=nuevo;	
		}else

		if (newVal>(*fatherNode).value[1] && newVal<(*fatherNode).value[2]){
			(*fatherNode).child[2]=nuevo;
		}else
		
	if (newVal>(*fatherNode).value[2]){
			(*fatherNode).child[3]=nuevo;
		}else{
			//newVal es repetido
			free(nuevo);
			return NULL;
		}
		//RETORNO EL NUEVO NODO CREADO
		return nuevo;
	}else{

		//SEGUNDO CASO: EL NODO NO ES NULL
		//ME FIJO SI ESTA LLENO EL NODO
		if ((*(*currNode)).len<3){
			return *currNode; 			//SI NO ESTA LLENO LO DEVUELVO PARA SER COMPLETADO CON EL VALOR
		}else{
			//EL NODO ESTA LLENO, ENTONCES DEBO BAJAR AL PROXIMO NODO
			fatherNode=*currNode;		//EL PADRE DEL PROXIMO ES EL NODO ACTUAL


//ME FIJO QUE HIJO APUNTA AL NODO CORRECTO DONDE SE DEBE AGREGAR NEWVAL

if (newVal<(*(*currNode)).value[0]){
			*currNode=(*(*currNode)).child[0];
		}
		if (newVal>(*(*currNode)).value[0] && newVal<(*(*currNode)).value[1]){
					*currNode=(*(*currNode)).child[1];

		}

		if (newVal>(*(*currNode)).value[1] && newVal<(*(*currNode)).value[2]){
					*currNode=(*(*currNode)).child[2];

		}

		if (newVal>(*(*currNode)).value[2]){
						*currNode=(*(*currNode)).child[3];

		}
//LLAMO A LA RECURSION 
		return ct_aux_search(currNode,fatherNode,newVal);
		}
	
	}
	
}

void ct_aux_fill(ctNode* currNode, uint32_t newVal){
	//Fijarse que no haya repetidos e insertarlo ordenado, y sumar 1 al arbol
	unsigned int valor0;
	unsigned int valor1;
	if (currNode->len==0){
		currNode->value[0]=newVal;
		}else if(currNode->len==1){
			if (newVal>currNode->value[0]){
				currNode->value[1]=newVal;
			}else if(newVal<currNode->value[0]){
				currNode->value[1]=currNode->value[0];
				currNode->value[0]= newVal;
			}else{
				return;
			}

		}else{
			valor0=currNode->value[0];
			valor1=currNode->value[1];

			if(valor0==newVal || valor1==newVal) return;

			if(newVal<valor0){
				currNode->value[0]=newVal;
				currNode->value[1]=valor0;
				currNode->value[2]=valor1;
			}else if(valor0<newVal && newVal<valor1){
				currNode->value[1]=newVal;
				currNode->value[2]=valor1;
			}else if(valor1<newVal){
				currNode->value[2]=newVal;
			}
		}
		currNode->len=currNode->len+1;
}

void ct_add(ctTree* ct, uint32_t newVal) {
ctNode* nodoDondeVa= ct_aux_search(&(*ct).root,NULL,newVal);
if (nodoDondeVa==NULL)return;
char sizeNodo= nodoDondeVa->len;
ct_aux_fill(nodoDondeVa,newVal); 
if (sizeNodo<nodoDondeVa->len){
	ct->size=ct->size+1;
}

	}

