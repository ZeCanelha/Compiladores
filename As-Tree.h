#include <stdio.h>
#include <stdlib.h>


typedef struct node node;

typedef struct node
{
  char * type;
  char * token;
  node * next_node;
  node * child_node;
}

/* TO DO: Enum para nao comparar as strings */

node * new_node(char *, char *);
void  add_sibiling( node *, node *);
void  add_child( node * , node *);
void print_tree ( node * , int );
