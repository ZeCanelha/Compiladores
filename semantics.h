#ifndef SEMANTICS_H
#define SEMANTICS_H


// Simbols

typedef struct sym_table
{
    char * id;
    char * type;
    char * flag;

    param_h * params;

    struct sym_table * next

}sym_table_node;

// Params

typedef struct params
{
    char * type;
    char * id;
    struct params * next;
}param_h;

// table_header

typedef struct table_h
{
    char * head;
    sym_table_node * lista_sym;
    param_h * l_params;
    struct table_h * next;

}table_header;

table_header * root_pointer;


sym_table_node * create_symbol(char * , param_h * , char * , char *);
table_header * create_table(char * , param_h *);
void add_table( table_header * , char * );
void print_table ( table_header * root );
void ast_to_sym_table( node_type * root );
void add_sym_to_table(table_header * ,char * , char * , param_h * , char *, int);

#endif
