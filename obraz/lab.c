#include <stdio.h>
#include <malloc.h>

#pragma pack(push,1)
typedef struct {
// struktura nagłówka (bitmap)
short int type; 
unsigned int size; 
short int reserved1; 
short int reserved2; 
unsigned int offset; 

//bitmap info header
unsigned int dib_header_size; 
unsigned int width; 
unsigned int height;  
unsigned short num_planes; 
unsigned short bits_per_pixel; 
unsigned int compression; 

unsigned int image_size_bytes; 
unsigned int yperm; 
unsigned int xperm; 
unsigned int num_colors; 
unsigned int important_colors; 
} bitmap;

#pragma pack(pop)
#pragma pack(push,1)

typedef struct {
unsigned char blue;
unsigned char green;
unsigned char red;
} pixel;
#pragma pack(pop)

FILE *dst;
FILE *src;
bitmap *mapa;

void negatyw(pixel *obraz,int szerokosc);
void pp(int i){printf("aaaaa=%d",i);};


int main()
	{
		dst = fopen("wynik.bmp","wb");
		src = fopen("ekran.bmp","rb");
		mapa = (bitmap*)calloc(1,sizeof(bitmap));
		

		int i = fread (mapa, 1, sizeof(bitmap), src);
		fwrite (mapa, 1, sizeof(bitmap), dst);

		int padding=4-(mapa->width %4);

		printf("szerokosc=%d wysokosc=%d bit na pixel=%d",mapa->width,  mapa->height,mapa->bits_per_pixel);
		pixel obraz[mapa->height][mapa->width];
		unsigned char puste[]={0,0,0};

		
		i=mapa->offset-1;
		while(i >0)
		{
			fread(puste,1,2,src);
			fwrite(puste,1,2,dst);
			i-=2;
		}

		 puste[0]=puste[1]=puste[2]=0;

		fseek(dst,mapa->offset,SEEK_SET);
		fseek(src,mapa->offset,SEEK_SET);
		i=0;
		while(i < mapa->height)
		{
			fread(obraz[i],sizeof(pixel),mapa->width,src);
			fseek(src,padding,SEEK_CUR);
			i++;
		}

		

void neg(){		
		for(int i=0;i<mapa->height;i++){negatyw(obraz[i],mapa->width*sizeof(pixel)/8);}
		if(mapa->width*sizeof(pixel)%8!=0){
		//for(int i=0;i<mapa->height;i++){negatyw_reszta(obraz[i],mapa->width*sizeof(pixel)*8,mapa->width*sizeof(pixel)%8 );}
		}
		fseek(dst,mapa->offset,SEEK_SET);
		i= 0;
		while(i < mapa->height)
		{
			fwrite(obraz[i],sizeof(pixel),mapa->width,dst);
			fwrite(puste,1,padding,dst);
			i++;
		}

	}	
	void odbicie()
	{//odbicie w pionie
		fseek(dst,mapa->offset,SEEK_SET);
	int i= mapa->height-1;
		while(i >=0)
		{
			fwrite(obraz[i],sizeof(pixel),mapa->width,dst);
			fwrite(puste,1,padding,dst);
			i--;
		}
	};



	void obrot()
	{//odbrot o 90 stopni
		int buf=mapa->height;
		mapa->height=mapa->width;
		mapa->width=buf;
		fseek(dst,0,SEEK_SET);
		fwrite (mapa, 1, sizeof(bitmap), dst);

		pixel temp[mapa->height][mapa->width];
		for(int i=0;i<mapa->height;i++){
	
			int ss=mapa->width-1;
			for(int j=0;j<mapa->width;j++){
			
			temp[i][j]=obraz[j][i];
			ss--;
			}
	
		}
		int padding=4-(mapa->width %4);
		fseek(dst,mapa->offset,SEEK_SET);

		i= 0;
		while(i < mapa->height)
		{
			fwrite(temp[i],sizeof(pixel),mapa->width,dst);
			fwrite(puste,1,padding,dst);
			i++;
		}
	};

		neg();
		//odbicie();
	//	obrot();//nie dziala

		fclose(src);
		fclose(dst);
		free(mapa);



		return 0;
	}













