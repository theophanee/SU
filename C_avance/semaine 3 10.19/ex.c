#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define DIM1 5
#define DIM2 6
#define PP printf("here\n")

void InitTab(char tab[DIM1][DIM2]){
	int i, j;
	for(i = 0; i < DIM1; i++){
		for(j = 0; j < DIM2; j++){
			tab[i][j] = '0';
		}
	}
}

void InitTab2(char *tab){
	int i, j;
	for(i = 0; i < DIM1; i++){
		for(j = 0; j < DIM2; j++){
			*((tab+i)+j) = '0';
		}
	}
}

void print_char_table(char t[DIM1][DIM2]){
    int i, j;
    for(i = 0; i < DIM1; i++){
        for(j = 0; j < DIM2; j++){
        	printf("%c  ",t[i][j]);	
        } 
        printf("\n");
    }
    printf("\n");
}

void print_char_table2(char *t){
    int i, j;
    for(i = 0; i < DIM1; i++){
        for(j = 0; j < DIM2; j++){
        	printf("%c  ",*((t+i)+j));
        }
        printf("\n");
    }
    printf("\n");
}

typedef struct _ty_etu{
	int id_etu;
	char nom[200], prenom[200];
	int nb_ue;
	char codes_ue[9][20];
	int notes[20];
}ty_etu;

ty_etu *lecture_ascii_etu(char *fichier){
	
	FILE *f;
	if(!(f = fopen(fichier, "r"))){
		printf("Impossible de lire le fichier");
		exit(1);
	}
	int nb_etu;
	int length_line = 200;
	char buffer[length_line];
	char* line = fgets(buffer, length_line, f);
	sscanf(line, "%d", &nb_etu);
	ty_etu* tab_etu = (ty_etu*) malloc(sizeof(ty_etu)*nb_etu);
	int i, j;
	char *buffer2;
	char *nom, *prenom, *codes_ue;
	int id_etu, nb_ue, notes;
	for(i = 0; i < nb_etu; i++){
		line = fgets(buffer, length_line, f);
		sscanf(buffer, "%d %s %s %d", &id_etu, nom, prenom, &notes);
		(tab_etu+i)->id_etu = id_etu;
		strcpy((tab_etu+i)->nom, nom);
		strcpy((tab_etu+i)->prenom, prenom);
 		(tab_etu+i)->nb_ue = nb_ue;
		for(j = 0; j < nb_ue; j++){
			sscanf(buffer, "%s %d", codes_ue, &notes);
			strcpy(*((tab_etu+i)->codes_ue+j), codes_ue);
			*((tab_etu+i)->notes+j) = notes;
		}
	}
	return tab_etu;
	
}

int main(void){
	
	// ex1
	char tab2D[DIM1][DIM2];
	char* tab2D2 = (char*) malloc(sizeof(char)*DIM1*DIM2);
	InitTab2(tab2D2);
	print_char_table2(tab2D2);


	// ex3
	ty_etu* tab_etu = lecture_ascii_etu("etu.txt");

	return 0;
}