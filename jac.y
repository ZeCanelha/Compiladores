%{

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "As-Tree.h"


  int yylex(void);
  void yyerror(char* s);
  int n_lines = 1;
  int n_column = 1;
  extern char* yytext;
  int flag = 0 ;
  int parse = 0;


  struct node_type * root = NULL;
  struct node_type * no_aux = NULL;
  struct node_type * aux = NULL;
  char string_type[15];

%}

%union
{
    char * token;
    struct node_type * no;
}


%token  BOOL
%token <token> BOOLLIT
%token  CLASS
%token  DO
%token  DOTLENGTH
%token  DOUBLE
%token  ELSE
%token  IF
%token  INT
%token  PARSEINT
%token  PRINT
%token  PUBLIC
%token  RETURN
%token  STATIC
%token  STRING
%token  VOID
%token  WHILE
%token  OCURV
%token  CCURV
%token  OBRACE
%token  CBRACE
%token  OSQUARE
%token  CSQUARE
%token  AND
%token  OR
%token  LT
%token  GT
%token  LEQ
%token  GEQ
%token  PLUS
%token  MINUS
%token  STAR
%token  DIV
%token  MOD
%token  NOT
%token  ASSIGN
%token  SEMI
%token  COMMA
%token  RESERVED
%token <token> ID
%token <token> REALLIT
%token <token> DECLIT
%token <token> STRLIT


%nonassoc NO_ELSE
%nonassoc ELSE


%type <no> Program
%type <no> ProgramAux
%type <no> FieldDecl
%type <no> FieldDeclAux
%type <no> MethodDecl
%type <no> MethodHeader
%type <no> MethodBody
%type <no> MethodBodyAux
%type <no> FormalParams
%type <no> FormalParamsAux
%type <no> VarDecl
%type <no> VarDeclAux
%type <no> Type
%type <no> Statement
%type <no> StatementAux
%type <no> Assignment
%type <no> MethodInvocation
%type <no> MethodInvocationAux
%type <no> ParseArgs
%type <no> Expr
%type <no> ExprAux





%start Program
%left COMMA
%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left STAR DIV MOD
%right NOT
%right PRECEDENCE
%left OBRACE OCURV OSQUARE CCURV CSQUARE CBRACE

%%

Program: CLASS ID OBRACE  ProgramAux  CBRACE                          {no_aux = new_node("Id",$2);root = new_node("Program",NULL);add_sibiling(no_aux,$4);add_child(root,no_aux);}
	;

ProgramAux
	: ProgramAux FieldDecl                                              {add_sibiling($1,$2); $$ = $1;}
	| ProgramAux MethodDecl                                             {add_sibiling($1,$2); $$ = $1;}
	| ProgramAux SEMI                                                   {$$ = $1;}
  | %empty                                                            {$$ = new_node("NULL",NULL);}



  FieldDecl
  : PUBLIC STATIC Type ID FieldDeclAux SEMI                           {no_aux = new_node("FieldDecl",NULL); add_child(no_aux,$3); add_sibiling(no_aux->child_node,new_node("Id",$4)); add_sibiling(no_aux,$5); $$ = no_aux;}
  | PUBLIC STATIC Type ID SEMI                                        {no_aux = new_node("FieldDecl",NULL); add_child(no_aux,$3); add_sibiling(no_aux->child_node,new_node("Id",$4)); $$ = no_aux;}
  | error SEMI                                                        {}
	;

FieldDeclAux
	: COMMA ID FieldDeclAux                                              {no_aux = new_node("FieldDecl", NULL); add_child(no_aux,new_node(string_type,NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux,$3); $$ = no_aux;}
  | COMMA ID                                                           {no_aux = new_node("FieldDecl", NULL); add_child(no_aux,new_node(string_type,NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); $$ = no_aux;}
  ;
MethodDecl: PUBLIC STATIC MethodHeader MethodBody                     {no_aux = new_node("MethodDecl",NULL); add_child(no_aux,$3); add_sibiling($3,$4);  $$ = no_aux;  }
  ;
MethodHeader
  : Type ID OCURV CCURV                                               {no_aux = new_node("MethodHeader",NULL); add_child(no_aux,$1); add_sibiling(no_aux->child_node,new_node("Id",$2));add_sibiling($1,new_node("MethodParams",NULL)); $$ = no_aux;}
	| Type ID OCURV FormalParams CCURV                                  {no_aux = new_node("MethodHeader",NULL); add_child(no_aux,$1); aux = new_node("MethodParams",NULL); add_sibiling(no_aux->child_node,new_node("Id",$2));add_sibiling($1,aux);add_child(aux,$4); $$ = no_aux;}
	| VOID ID OCURV CCURV                                               {no_aux = new_node("MethodHeader", NULL); add_child(no_aux,new_node("Void",NULL));add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux->child_node,new_node("MethodParams",NULL));$$ = no_aux;}
	| VOID ID OCURV FormalParams CCURV                                  {no_aux = new_node("MethodHeader",NULL); add_child(no_aux,new_node("Void",NULL)); aux = new_node("MethodParams",NULL); add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux->child_node,aux); add_child(aux,$4);$$ = no_aux;}
	;


MethodBody
	: OBRACE MethodBodyAux CBRACE                                       {no_aux = new_node("MethodBody",NULL); add_child(no_aux,$2); $$ = no_aux;}
	;


MethodBodyAux
	: MethodBodyAux VarDecl                                             {add_sibiling($1,$2); $$ = $1;}
  | MethodBodyAux Statement                                           {/*add_sibiling($1,$2); $$ = $1;*/}
  | %empty                                                            {$$ = new_node("NULL",NULL);}
	;


FormalParams
	: Type ID FormalParamsAux                                           {no_aux = new_node("ParamDecl",NULL);add_child(no_aux,$1);add_sibiling($1,new_node("Id",$2));add_sibiling(no_aux,$3); $$ = no_aux;}
	| STRING OSQUARE CSQUARE ID                                         {no_aux = new_node("ParamDecl",NULL);add_child(no_aux,new_node("StringArray",NULL)); add_sibiling(no_aux->child_node,new_node("Id",$4)); $$ = no_aux;}
  | Type ID                                                           {no_aux = new_node("ParamDecl",NULL);add_child(no_aux,$1); add_sibiling($1,new_node("Id",$2)); $$ = no_aux; }
  ;

FormalParamsAux
	: COMMA Type ID FormalParamsAux                                     {no_aux = new_node("ParamDecl",NULL); add_child(no_aux,$2); add_sibiling($2,new_node("Id",$3));add_sibiling(no_aux,$4); $$ = no_aux;}
	| COMMA Type ID                                                     {no_aux = new_node("ParamDecl",NULL); add_child(no_aux,$2); add_sibiling($2,new_node("Id",$3)); $$ = no_aux;}
	;


VarDecl
	: Type ID VarDeclAux SEMI                                          {no_aux = new_node("VarDecl",NULL); add_child(no_aux,$1);add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux,$3);$$ = no_aux;}
  | Type ID SEMI                                                     {no_aux = new_node("VarDecl",NULL); add_child(no_aux,$1); add_sibiling($1,new_node("Id",$2)); $$ = no_aux;}
  ;
VarDeclAux
  : COMMA ID VarDeclAux                                              {no_aux = new_node("VarDecl",NULL); add_child(no_aux,new_node(string_type,NULL));add_sibiling(no_aux->child_node,new_node("Id",$2));add_sibiling(no_aux,$3);$$ = no_aux;}
  | COMMA ID                                                         {no_aux = new_node("VarDecl",NULL); add_child(no_aux,new_node(string_type,NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); $$ = no_aux;}
  ;

Type: BOOL                                                            {$$ = new_node("Bool",NULL);strcpy(string_type,"Bool");}
	| INT                                                               {$$ = new_node("Int",NULL);strcpy(string_type,"Int");}
	| DOUBLE                                                            {$$ = new_node("Double",NULL);strcpy(string_type,"Double");}
	;

Statement: OBRACE StatementAux CBRACE                                 {}
	| IF OCURV Expr CCURV Statement %prec NO_ELSE                       {}
	| IF OCURV Expr CCURV Statement ELSE Statement                      {}
	| WHILE OCURV Expr CCURV Statement                                  {}
	| DO Statement WHILE OCURV Expr CCURV SEMI                          {}
	| PRINT OCURV Expr CCURV SEMI                                       {}
	| PRINT OCURV STRLIT CCURV SEMI                                     {}
	| SEMI                                                              {$$ = NULL;}
	| Assignment SEMI                                                   {}
  | Assignment ParseArgs SEMI                                         {}
  | Assignment MethodInvocation SEMI                                  {}
  | Assignment MethodInvocation ParseArgs SEMI                        {}
	| MethodInvocation SEMI                                             {}
  | MethodInvocation ParseArgs SEMI                                   {}
	| ParseArgs SEMI                                                    {}
	| RETURN  SEMI                                                      {}
	| RETURN  Expr SEMI                                                 {}
	| error SEMI                                                        {}
	;

StatementAux
	: StatementAux Statement                                            {}
  | %empty                                                            {}
  ;

Assignment: ID ASSIGN Expr                                            {}
  ;

MethodInvocation: ID OCURV CCURV                                      {}
	| ID OCURV Expr MethodInvocationAux CCURV                           {}
	| ID OCURV error CCURV                                              {}
	;

MethodInvocationAux
	: MethodInvocationAux COMMA Expr                                    {}
  | %empty                                                            {}
	;


ParseArgs: PARSEINT OCURV ID OSQUARE Expr CSQUARE CCURV                    {}
	| PARSEINT OCURV error CCURV                                             {}
	;


Expr: Assignment                                                            {}
	| ExprAux
	;

  ExprAux
  : MethodInvocation                                                       {}
  	| ParseArgs                                                            {}
  	| ExprAux AND ExprAux                                                  {}
  	| ExprAux OR ExprAux                                                   {}
  	| ExprAux EQ ExprAux                                                   {}
  	| ExprAux GEQ ExprAux                                                  {}
  	| ExprAux GT ExprAux                                                   {}
  	| ExprAux LEQ ExprAux                                                  {}
  	| ExprAux LT ExprAux                                                   {}
  	| ExprAux NEQ ExprAux                                                  {}
  	| ExprAux PLUS ExprAux                                                 {}
  	| ExprAux STAR ExprAux                                                 {}
    | ExprAux MINUS ExprAux                                                {}
  	| ExprAux DIV ExprAux                                                  {}
  	| ExprAux MOD ExprAux                                                  {}
    | PLUS ExprAux                                                         {}
  	| MINUS ExprAux                                                        {}
  	| NOT ExprAux                                                          {}
  	| ID                                                                   {}
  	| ID DOTLENGTH                                                         {}
  	| OCURV ExprAux CCURV                                                  {}
  	| BOOLLIT                                                              {}
  	| DECLIT                                                               {}
  	| REALLIT                                                              {}
  	| OCURV error CCURV                                                    {}
  	;


%%


int main(int argc, char *argv[]) {


	if (argc >= 2)
	{
		if(strncmp(argv[1],"-l",2)==0)
		{
			flag=1;
			yylex();

		}
		if(strncmp(argv[1],"-1",2)==0)
		{
			flag=0;
			yylex();
		}
    if ( strncmp(argv[1],"-t",2) == 0)
    {
      parse = -1;
      yyparse();
      print_tree(root,0);
    }



	}
	if (argc == 1 )
	{
		parse = -1;
    yyparse();
	}

	return 0;
}
void yyerror(char* s)
{
	if ( parse == -1)
  {
		printf("Line %d, col %d: %s: %s\n", n_lines, (int)(n_column - strlen(yytext)), s, yytext);
  }
}
