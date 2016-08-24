#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
    char* name = "cambiameporotronombre.txt";
    FILE *pFile = fopen( name, "a" );
    


//EJEMPLO DE COMO LLAMAR A NEW
    /*ctTree* pct; 
	ct_new(&pct);
*/
    fprintf(pFile,"-\n");
        
    fclose( pFile );
    return 0;    
}