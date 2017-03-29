#include <stdio.h>
#include <stdlib.h>

typedef struct node_type
{
  char * type;
  char * token;
  struct node_type * next_node;
  struct node_type * child_node;
}node_type;


/* TO DO: Enum para nao comparar as strings */

node_type * new_node(char *, char *);
void add_child( node_type *  , node_type *);
void add_sibiling ( node_type * , node_type * );
void print_tree ( node_type * , int );
