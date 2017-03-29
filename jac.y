%{

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "As-Tree.c"


  int yylex(void);
  void yyerror(char* s);
  int n_lines = 1;
  int n_column = 1;
  extern char* yytext;
  int flag = 0 ;
  int parse = 0;

  /*
    * O nó root representa a raiz da AST.
    * O nó no_aux é um auxiliar para criar novos nós.
    */
  struct node_type * root = NULL;
  struct node_type * no_aux = NULL;

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

Program: CLASS ID OBRACE  ProgramAux  CBRACE                          {root = new_node("Program",NULL); no_aux = new_node("Id",$2);add_child(root,no_aux);add_sibiling(no_aux,$4);   }
	;

ProgramAux
	: ProgramAux FieldDecl                                              {add_sibiling($1,$2); $$ = $1;}
	| ProgramAux MethodDecl                                             {add_sibiling($1,$2); $$ = $1;}
	| ProgramAux SEMI                                                   {$$ = $1;}
  | %empty                                                            {$$ = new_node("NULL",NULL);}



  FieldDecl
  : PUBLIC STATIC Type ID FieldDeclAux SEMI                           {}
  | error SEMI                                                        {}
	;

FieldDeclAux
	: FieldDeclAux COMMA ID                                             {}
  | %empty                                                            {}
  ;
MethodDecl: PUBLIC STATIC MethodHeader MethodBody                     {no_aux = new_node("MethodDecl",NULL); add_child(no_aux,$3); add_sibiling($3,$4);  $$ = no_aux;  }
  ;
MethodHeader
  : Type ID OCURV CCURV                                               {no_aux = new_node("MethodHeader",NULL); add_child(no_aux,new_node("Id",$2)); add_child(no_aux,new_node("Type",NULL)); $$ = no_aux;}
	| Type  ID OCURV FormalParams CCURV                                 {}
	| VOID ID OCURV CCURV                                               {}
	| VOID ID OCURV FormalParams CCURV                                  {no_aux = new_node("MethodHeader",NULL); add_child(no_aux,new_node("Void",NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux->child_node,$4);$$ = no_aux;}
	;


MethodBody
	: OBRACE MethodBodyAux CBRACE                                       {}
	;


MethodBodyAux
	: MethodBodyAux VarDecl                                             {}
	| MethodBodyAux Statement                                           {}
  | %empty                                                            {}
	;


FormalParams
	: Type ID FormalParamsAux                                           {}
	| STRING OSQUARE CSQUARE ID                                         {}
	;


FormalParamsAux
	: FormalParamsAux COMMA Type ID                                     {}
	| %empty                                                            {}
	;


VarDecl
	: Type ID FieldDeclAux SEMI                                         {}
	;

Type: BOOL                                                            {}
	| INT                                                               {}
	| DOUBLE                                                            {}
	;

Statement: OBRACE StatementAux CBRACE                                 {}
	| IF OCURV Expr CCURV Statement %prec NO_ELSE                       {}
	| IF OCURV Expr CCURV Statement ELSE Statement                      {}
	| WHILE OCURV Expr CCURV Statement                                  {}
	| DO Statement WHILE OCURV Expr CCURV SEMI                          {}
	| PRINT OCURV Expr CCURV SEMI                                       {}
	| PRINT OCURV STRLIT CCURV SEMI                                     {}
	| SEMI                                                              {}
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
	| MethodInvocation                                                        {}
	| ParseArgs                                                               {}
	| Expr AND ExprAux                                                        {}
	| Expr OR ExprAux                                                         {}
	| Expr EQ ExprAux                                                         {}
	| Expr GT ExprAux                                                         {}
  | Expr GEQ ExprAux                                                        {}
	| Expr LEQ ExprAux                                                        {}
	| Expr LT ExprAux                                                         {}
	| Expr NEQ ExprAux                                                        {}
	| Expr PLUS ExprAux                                                       {}
	| Expr MINUS ExprAux                                                      {}
	| Expr STAR ExprAux                                                       {}
	| Expr DIV ExprAux                                                        {}
	| Expr MOD ExprAux                                                        {}
	| PLUS ExprAux                                                            {}
	| MINUS ExprAux                                                           {}
	| NOT ExprAux                                                             {}
	| ID                                                                      {}
	| ID DOTLENGTH                                                            {}
	| OCURV Expr CCURV                                                        {}
	| BOOLLIT                                                                 {}
	| DECLIT                                                                  {}
	| REALLIT                                                                 {}
	| OCURV error CCURV                                                       {}
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
