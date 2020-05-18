#include<stdio.h>
#include <stdlib.h>
int suma(int a, int b);
extern void print_fibb(int f)
{	printf("wynik ciagu fibonacciego= %d\n",f);
}
unsigned long myTime();
void add(int **t,int **k)
{
	int n=0;
	for(int i=0;i<5;i++)
	{
		for(int j=0;j<5;j++)
		{
			
		
		    asm (
					
				"movl (%0,%%ecx,4),%%eax\n\t"
				"movl (%1,%%ecx,4),%%ebx\n\t"	

				"movl (%%ebx,%%edi,4),%%ebx\n\t" 				
				"addl %%ebx,(%%eax,%%edi,4) \n\t" 

			     :
			     : "r" (t),"r"(k),"D"(j), "c"(i)
			    );
		}
	}



};



int main()
{

	int s= suma(3,3);
		

    int **t=(int**) malloc(5*sizeof(int*));
    int **k=(int**) malloc(5*sizeof(int*));

    for(int i=0;i<5;i++)
        {
			t[i]=(int*) malloc(5*sizeof(int));
			k[i]=(int*) malloc(5*sizeof(int));

            for(int j=0;j<5;j++)
               {
                   t[i][j]=1;
                   k[i][j]=2;

                }
        }
	long time=myTime();
	add(t,k);
	time=myTime()-time;
	for(int i=0;i<5;i++)
        {
			for(int j=0;j<5;j++)printf("%d ",t[i][j]);
         	 printf("\n "); 
		  }
		printf("\ntime %lu\n",time);
       


}
