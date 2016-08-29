#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
	int a=10;
	int b=50;
	int c=30;
	int d=5;
	int e=20;
	int f=40;
	int g=60;
	int h=19;
	int i=39;
	int j=4;
    char* name = "archivito.txt";
    FILE *pFile = fopen( name, "a" );
    ctTree* pct; 
    ct_new(&pct);
    ct_add(pct,a);
    ct_add(pct,b);
    ct_add(pct,c);
    ct_add(pct,d);
    ct_add(pct,e);
    ct_add(pct,f);
    ct_add(pct,g);
    ct_add(pct,h);
    ct_add(pct,i);
    ct_add(pct,j);
    ct_print(pct,pFile);


    ctIter* iter = ctIter_new(pct);
    ctIter_first(iter);
    while(ctIter_valid(iter)==1){
    	printf("%d\n",ctIter_get(iter));
    	ctIter_next(iter);
    }
  ctIter_delete(iter);

    ct_delete(&pct);
    
    fprintf(pFile,"-\n");
        
    fclose( pFile );
    
    return 0;    
}