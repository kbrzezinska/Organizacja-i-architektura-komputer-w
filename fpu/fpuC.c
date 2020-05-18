#include<stdio.h>
#include <stdlib.h>

extern float excep();
extern float fib(float a);
extern float fpow(float a,float b);//a^b
extern float fibb_iter(float a);
extern void control();
extern void pp(float f)
{	printf("wynik %f\n",f);
}
int main()
{
	//control();
		float f=fib(3);
	//float f=fibb_iter(6.0);
	//float f=excep();
	printf("wynik %f",f);

}


