#include "As-Tree.h"

/* TYPE eg: Program */
/* Token = value */


node_type * new_node ( char * tipo , char * token )
{
  node_type * no = (node_type *) malloc ( sizeof(node_type));

  no->type = strdup(tipo);
  no->token = token;
  no->next_node = NULL;
  no->child_node = NULL;
  return no;
}

void add_child ( node_type * parent , node_type * child )
{
      parent->child_node = child;
}

void add_sibiling ( node_type * first_bro , node_type * new_bro )
{
  if ( first_bro != NULL )
  {
    while( first_bro->next_node != NULL )
      first_bro = first_bro->next_node;
    first_bro->next_node = new_bro;
  }
}


void print_tree (node_type * no, int n_points) {
	int i;
	if(no == NULL)
		return;
	for(i=0; i< n_points; i++)
		printf(".");
	if(no->token != NULL )
		printf("%s(%s)\n", no->type, no->token);
	else{

    if ( !strcmp(no->type,"NULL") != 0);
    else
      printf("%s\n", no->type);
  }


	print_tree(no->child_node, n_points+2);
	print_tree(no->next_node, n_points);
}
