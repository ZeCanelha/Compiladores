#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "As-Tree.h"
#include "semantics.h"


sym_table_node * create_symbol ( char * id , param_h * paramtype , char * type, char * flag )
{
    sym_table_node * new_symb = (sym_table_node *) malloc ( sizeof(sym_table_node));

    new_symb->id = ( char *) malloc (strlen(id)*sizeof(char));
    new_symb->type = ( char *) malloc (strlen(type)*sizeof(char));
    new_symb->flag = ( char *) malloc (strlen(flag)*sizeof(char));

    strcpy(new_symb->id,id);
    strcpy(new_symb->type,type);
    strcpy(new_symb->flag,flag);

    new_symb->params = paramtype;
    new_symb->next = NULL;

    return new_symb;

}

table_header * create_table ( char * name , param_h * paramtype )
{

    table_header * new_table = ( table_header *) malloc( sizeof(table_header));
    new_table->head = ( char *) malloc(strlen(name) * sizeof(char));

    strcpy(new_table->head,name);
    new_table->l_params = paramtype;
    new_table->lista_sym = NULL;
    new_table->next = NULL;

    return new_table;
}

void add_table ( table_header * root, char * name , param_h * paramtype)
{
    table_header * aux_table = root;

    while(aux_table->next != NULL )
    {
        aux_table = aux_table->next;
    }
    char * temp_name = ( char * ) malloc ( 100 * sizeof(char));
    strcpy(temp_name,"===== Method ");
    strcat(temp_name,name);
    strcat(temp_name," Symbol Table =====");

    aux_table->next = create_table(temp_name,paramtype);
    //aux_table = aux_table->next;
}

void add_sym_to_table( table_header * root, char * id , char * type, param_h * paramtype , char * flag, int n_table )
{
    table_header * root_aux = root;
    if ( n_table == 1 )
    {
        if ( root_aux != NULL )
        {
            root_aux->lista_sym = create_symbol(id,paramtype,type,flag);
            root_aux->l_params = paramtype;
        }
    }
    else
    {
        while(root_aux->next)
            root_aux = root_aux->next;
    }
    root_aux->lista_sym = create_symbol(id,paramtype,type,flag);
    root_aux->l_params = paramtype;
}


void ast_to_sym_table( node_type * root , table_header * table_root)
{
    node_type * root_aux;
    root_aux = root->child_node;
    node_type * child_aux;
    char head[50];
    char type[10];
    param_h * params;

    while (root_aux)
    {
        if ( strcmp(root_aux->type, "NULL")!= 0)
        {
            if ( strcmp(root_aux->type,"FieldDecl") == 0 )
            {
                child_aux = root_aux->child_node;
                //printf("Type: %s\nId: %s\n",child_aux->type,child_aux->next_node->token);
                add_sym_to_table(table_root,child_aux->next_node->token,child_aux->type,NULL,"",2);


            }
            else if ( strcmp(root_aux->type,"MethodDecl") == 0)
            {
                // Actualizar tbm na tabela global
                // Header -> nome da tabelas
                // Body -> variaveis
                child_aux = root_aux->child_node;
                if ( strcmp(child_aux->type,"MethodHeader") == 0)
                {
                    strcpy(head,child_aux->child_node->next_node->token);
                    strcpy(type,child_aux->child_node->type);
                }
                child_aux = child_aux->child_node;
                while( child_aux )
                {
                    if ( strcmp(child_aux->type,"MethodParams") == 0)
                        break;
                    child_aux = child_aux->next_node;
                }
                params = get_params(child_aux);
                while(params)
                {
                    printf("Id: %s\tType: %s\n", params->id,params->type);
                    params = params->next;
                }

                //add_table(table_root,head,params);

            }
        }
        root_aux = root_aux->next_node;
    }
}


param_h * create_param( char * id , char * type)
{
    //TODO: converter as cenas do String[] e cenas para minuscula
    param_h * params = ( param_h * ) malloc(sizeof(param_h));
    params->id = (char *) malloc ( strlen(id) * sizeof(char));
    params->type = ( char * ) malloc (strlen(type) * sizeof(char));

    strcpy(params->id,id);
    strcpy(params->type,type);
    params->next = NULL;

    return params;

}

param_h * get_params( node_type * node )
{
    param_h * param = NULL;
    param_h * aux;
    node_type * aux_node = node->child_node;

    param = create_param(aux_node->child_node->next_node->token,aux_node->child_node->type);
    aux = param;
    aux_node = aux_node->next_node;
    if ( aux_node == NULL )
        return param;
    else
    {
        while(aux_node)
        {
            aux->next = create_param(aux_node->child_node->next_node->token,aux_node->child_node->type);
            aux_node = aux_node->next_node;
            aux = aux->next;
        }
    }
    return param;
}

void print_table( table_header * root)
{
    table_header * root_aux = root;
    int aux = 0;


    while (root_aux)
    {
        printf("%s\n",root_aux->head);
        printf("%s\t",root_aux->lista_sym->id);


        while( root_aux->l_params )
        {
            if ( aux == 0 )
            {
                printf("(");
                aux = 1;
            }
            else
            {
                printf(",");
            }
            printf("%s",root_aux->l_params->type);
            root_aux->l_params = root_aux->l_params->next;
        }
        if ( aux != 0 )
        {
            printf(")");
        }

        printf("\t%s",root_aux->lista_sym->type);
        if ( strcmp(root_aux->lista_sym->flag,"") != 0 )
        {
            printf("\t%s",root_aux->lista_sym->flag);
        }
        printf("\n");

        root_aux = root_aux->next;
    }
}
