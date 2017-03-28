#include <stdio.h>
#include <stdlib.h>


typedef struct node node;

typedef struct node
{
  int value;
  char * token;
  node * next_node;
  node * child_node;
}

node * new_node(char *, int );
void * add_sibiling( node *, char * , int);
void * add_child( node * , char * , int );
