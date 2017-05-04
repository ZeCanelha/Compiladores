#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "As-Tree.h"
#include "semantics.h"


sym_table_node * create_symbol ( char * id , param_h * paramtype , char * type, char * flag )
{
    sym_table_node * new_symb = (sym_table_node *) malloc ( sizeof(sym_table_node));

    new_symb->id = ( char *) malloc (strlen(id)*sizeof(char)+1);
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
    new_table->head = ( char *) malloc(strlen(name) * sizeof(char)+1);
    strcpy(new_table->head,name);
    new_table->l_params = paramtype;
    new_table->lista_sym = NULL;
    new_table->next = NULL;

    return new_table;
}

void add_table ( table_header * root, char * name , param_h * paramtype_aux)
{
    table_header * aux_table = root;

    while(aux_table->next != NULL )
    {
        aux_table = aux_table->next;
    }
    //printf("-->>> %s\n",paramtype_aux->id);
    aux_table->next = create_table(name,paramtype_aux);
}

void add_sym_to_table( table_header * root, char * id , char * type, param_h * paramtype , char * flag, int n_table , int f )
{
    table_header * root_aux = root;
    sym_table_node * aux;
    param_h * params_aux;
    if ( n_table == 1 )
    {
        if ( root_aux != NULL )
        {
            aux = root_aux->lista_sym;
            if ( aux == NULL )
            {
                if ( paramtype == NULL && f == 0)
                {
                    params_aux = create_param("","");
                    root_aux->lista_sym = create_symbol(id,params_aux,type,flag);
                }
                else
                {
                    root_aux->lista_sym = create_symbol(id,paramtype,type,flag);
                }
            }
            else
            {
                while( aux->next != NULL)
                    aux = aux->next;

                if ( paramtype == NULL && f == 0)
                {
                    params_aux = create_param("","");
                    aux->next = create_symbol(id,params_aux,type,flag);
                }
                else
                {
                    aux->next = create_symbol(id,paramtype,type,flag);
                }
            }
        }
    }
    else
    {
        while(root_aux->next)
            root_aux = root_aux->next;
        aux = root_aux->lista_sym;
        if ( aux == NULL)
        {
            root_aux->lista_sym = create_symbol(id,paramtype,type,flag);
            //root_aux->l_params = paramtype;
        }
        else
        {
            while( aux->next != NULL)
                aux = aux->next;
            aux->next = create_symbol(id,paramtype,type,flag);

        }

    }
}


void ast_to_sym_table( node_type * root , table_header * table_root)
{
    node_type * root_aux;
    root_aux = root->child_node;
    node_type * child_aux;
    node_type * bro_aux;
    table_header * table_aux = table_root;
    char head[100];
    char type[10];
    char return_id[10];
    param_h * params;
    param_h * params_aux;

    while (root_aux)
    {
        if ( strcmp(root_aux->type, "NULL")!= 0)
        {
            if ( strcmp(root_aux->type,"FieldDecl") == 0 )
            {
                child_aux = root_aux->child_node;
                //printf("Type: %s\nId: %s\n",child_aux->type,child_aux->next_node->token);
                //if ( check_double_var(table_root,child_aux->next_node->token) == 0)
                add_sym_to_table(table_root,child_aux->next_node->token,child_aux->type,NULL,"",1,1);


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
                    strcpy(return_id,type);

                    child_aux = child_aux->child_node;
                    while( child_aux )
                    {
                        if ( strcmp(child_aux->type,"MethodParams") == 0)
                            break;
                        child_aux = child_aux->next_node;
                    }
                    params = get_params(child_aux);
                    add_sym_to_table(table_root,head,type,params,"",1,0);
                    add_table(table_root,head,params);

                }
                bro_aux = root_aux->child_node->next_node;
                if ( strcmp(bro_aux->type,"MethodBody") == 0 )
                {
                    while ( table_aux->next != NULL )
                        table_aux = table_aux->next;
                    if ( table_aux->l_params != NULL )
                    {
                        params_aux = table_aux->l_params;
                        add_sym_to_table(table_root,"return",return_id,NULL,"",2,1);
                        while(params_aux)
                        {
                            add_sym_to_table(table_root,params_aux->id,params_aux->type,NULL,"param",2,1);
                            params_aux = params_aux->next;
                        }
                    }
                    else
                        add_sym_to_table(table_root,"return",return_id,NULL,"",2,1);
                    bro_aux = bro_aux->child_node;
                    while ( bro_aux )
                    {
                        if ( strcmp(bro_aux->type,"VarDecl") == 0 )
                        {
                            add_sym_to_table(table_root,bro_aux->child_node->next_node->token,bro_aux->child_node->type,NULL,"",2,1);
                        }
                        bro_aux = bro_aux->next_node;
                    }
                }
            }
        }
        root_aux = root_aux->next_node;
    }
}


param_h * create_param( char * id , char * type)
{
    //TODO: converter as cenas do String[] e cenas para minuscula
    param_h * params = ( param_h * ) malloc(sizeof(param_h));
    params->id = (char *) malloc ( strlen(id) * sizeof(char)+1);
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
    if  ( node->child_node == NULL )
        return NULL;
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
    sym_table_node * sym_aux;
    param_h * paramtype;
    int aux = 0;
    int i = 0;


    while (root_aux)
    {

        printf("===== ");
        if ( i == 0 )
            printf("Class ");
        else
            printf("Method ");
        printf("%s",root_aux->head);
        paramtype = root_aux->l_params;
        if ( paramtype != NULL )
        {
            printf("(");
            while(paramtype)
            {
                if ( paramtype->next != NULL )
                {
                    if ( strcmp(paramtype->type,"StringArray") == 0 )
                        printf("String[]");
                    else if ( strcmp(paramtype->type,"Bool") == 0 )
                        printf("boolean");
                    else
                    {
                        printf("%s",toLowerCase(paramtype->type));

                    }
                    printf(",");

                }
                else
                {
                    if ( strcmp(paramtype->type,"StringArray") == 0 )
                        printf("String[]");
                    else if ( strcmp(paramtype->type,"Bool") == 0 )
                        printf("boolean");
                    else
                    {
                        printf("%s",toLowerCase(paramtype->type));

                    }
                    printf(")");
                }

                paramtype = paramtype->next;
            }

        }
        else
        {
            if (i != 0)
                printf("()");
        }
        printf(" Symbol Table =====\n");


        sym_aux = root_aux->lista_sym;
        while(sym_aux)
        {
            printf("%s\t",sym_aux->id);
            paramtype = sym_aux->params;
            while( paramtype )
            {
                if( aux == 1)
                {
                    printf(",");
                }
                if ( aux == 0 )
                {
                    printf("(");
                    aux = 1;
                }
                if ( strcmp(paramtype->type,"StringArray") == 0 )
                    printf("String[]");
                else if ( strcmp(paramtype->type,"Bool") == 0 )
                    printf("boolean");
                else
                    printf("%s",toLowerCase(paramtype->type));

                paramtype = paramtype->next;
            }
            if ( aux != 0 )
            {
                printf(")");
                aux = 0;
            }
            if ( strcmp(sym_aux->type,"Bool") == 0 )
                printf("\tboolean");
            else if ( strcmp(sym_aux->type,"StringArray") == 0 )
                printf("\tString[]");
            else
                printf("\t%s",toLowerCase(sym_aux->type));

            if ( strcmp(sym_aux->flag,"") != 0 )
            {
                printf("\t%s",sym_aux->flag);
            }
            sym_aux = sym_aux->next;
            printf("\n");
        }
        printf("\n");

        root_aux = root_aux->next;
        i++;
    }
}


int check_double_var(table_header * root , char * id )
{
    sym_table_node * sym_tab = root->lista_sym;


    while ( sym_tab )
    {
        if ( strcmp(sym_tab->id,id) == 0 )
        {
            return 1;
        }
        sym_tab = sym_tab->next;
    }
    return 0;
}


char * toLowerCase( char * str )
{
	int i;
	for(i = 0; str[i]; i++){
        if ((str[i] >= 65) && (str[i] <= 90))
            str[i] = str[i] + 32;
    }
	return str;
}

void print_tables_params( table_header * root )
{
    table_header * root_aux = root;

    while ( root_aux )
    {
        printf("%s\n", root_aux->head);
        if ( root_aux->l_params != NULL )
        {
            printf("Entrei!\n");
            printf("ID: %s\tTYPE: %s\n",root_aux->l_params->id,root_aux->l_params->type);
        }
        else
            printf("Não tenho params.\n");

        root_aux = root_aux->next;
    }

}
