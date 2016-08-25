#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
    char* name = "cambiameporotronombre.txt";
    FILE *pFile = fopen( name, "a" );
    


//EJEMPLO DE COMO LLAMAR A NEW
    ctTree* pct; 
    ct_new(&pct);
    printf("%d\n",(*pct).size);
	
    ct_add(pct,1000);
    printf("%d\n",pct->root->value[0]);
    ct_add(pct,1001);
    printf("%d\n",pct->root->value[1]);
    ct_add(pct,1002);
    printf("%d\n",pct->root->value[2]);
    ct_add(pct,1003);
    ctNode* fede= pct->root->child[3];
    printf("%d\n",fede->value[0]);
    fprintf(pFile,"-\n");
        
    fclose( pFile );
    
    return 0;    
}