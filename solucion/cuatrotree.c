#include "cuatrotree.h"

ctNode* aux(ctNode* actual,uint32_t newVal,uint32_t hijo){
//Si el hijo existe entonces hago recursion
	if(actual->child[hijo]!=NULL){
		return ct_aux_search(&actual->child[0],actual,newVal);
	}//El hijo no existe entonces creo un nodo nuevo
	else{
		ctNode* nuevo= malloc(53);
		nuevo->father=actual;
		nuevo->len=0;
		for (int i = 0; i < 4; i++)	{
			nuevo->child[i]=NULL;
		}
		actual->child[0]=nuevo;
		return nuevo;
	}			
}

ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
	ctNode* nodoActual= *currNode;
	ctNode* result=NULL;
	//Caso base el nodo no esta lleno
	if (nodoActual->len<3){
		result= nodoActual;
	}
	//Esta lleno el nodo 

	//El valor iria en el nodo que apunta child[0]
if (newVal<nodoActual->value[0]){
	result= aux(nodoActual,newVal,0);
		}
//El valor iria en el nodo que apunta al child[1]
		if (newVal>nodoActual->value[0] && newVal<nodoActual->value[1]){
					result= aux(nodoActual,newVal,1);
		}

		if (newVal>nodoActual->value[1] && newVal<nodoActual->value[2]){
					result= aux(nodoActual,newVal,2);
		}
		
	if (newVal>nodoActual->value[2]){
					result= aux(nodoActual,newVal,3);
		}
		return result;

}

void ct_aux_fill(ctNode* currNode, uint32_t newVal){
	//Fijarse que no haya repetidos e insertarlo ordenado
}

void ct_add(ctTree* ct, uint32_t newVal) {
ctNode* nodoDondeVa= ct_aux_search(&ct,NULL,newVal);
ct_aux_fill(nodoDondeVa,newVal);
	}

