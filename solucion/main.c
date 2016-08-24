#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
   /* char* name = "cambiameporotronombre.txt";
    FILE *pFile = fopen( name, "a" );
    */


//EJEMPLO DE COMO LLAMAR A NEW
    ctTree* pct; 
    ct_new(&pct);
    printf("%d\n",(*pct).size);

	//ct_add(pct,10);









	/*

    fprintf(pFile,"-\n");
        
    fclose( pFile );
    */
    return 0;    
}