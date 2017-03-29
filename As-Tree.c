#include "As-Tree.h"


node * new_node ( char * tipo , char * token )
{
  node * no = (node *) malloc ( sizeof(struct node));

  no->type = strdup(tipo);
  no->token = token;
  no->next_node = NULL;
  no->child_node = NULL;

  return no;
}


void add_sibiling( node * bro , node * new_bro )
{
  if ( bro != NULL )
  {
    while (bro->next_node != NULL) {
      bro = bro->next_node;
    }
    bro->next_node = new_bro;
  }
}

void add_child ( node * parent , node * child )
{
  parent->child = child;
}

void print_tree (node * no, int n_points) {
	int i;

	if(no == NULL)
		return;

	for(i=0; i< n_points; i++)
		printf(".");

	if(no->token != NULL)
		printf("%s(%s)\n", no->type, no->token);
	else
		printf("%s\n", no->type);

	print_ast(no->child_node, n_points+2);
	print_ast(no->next_node, n_points);
}
