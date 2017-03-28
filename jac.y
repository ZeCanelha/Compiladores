%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(char* s);
int n_lines = 1;
int n_column = 1;
extern char* yytext;
int flag = 0 ;
int parse = 0;

%}


%union
{
    char* token;
    int inteiro;
}




%token <token> BOOL
%token <token> BOOLLIT
%token <token> CLASS
%token <token> DO
%token <token> DOTLENGTH
%token <token> DOUBLE
%token <token> ELSE
%token <token> IF
%token <token> INT
%token <token> PARSEINT
%token <token> PRINT
%token <token> PUBLIC
%token <token> RETURN
%token <token> STATIC
%token <token> STRING
%token <token> VOID
%token <token> WHILE
%token <token> OCURV
%token <token> CCURV
%token <token> OBRACE
%token <token> CBRACE
%token <token> OSQUARE
%token <token> CSQUARE
%token <token> AND
%token <token> OR
%token <token> LT
%token <token> GT
%token <token> LEQ
%token <token> GEQ
%token <token> PLUS
%token <token> MINUS
%token <token> STAR
%token <token> DIV
%token <token> MOD
%token <token> NOT
%token <token> ASSIGN
%token <token> SEMI
%token <token> COMMA
%token <token> RESERVED
%token <token> ID
%token <token> REALLIT
%token <token> DECLIT
%token <token> STRLIT


%nonassoc NO_ELSE
%nonassoc ELSE


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

Program: CLASS ID OBRACE  ProgramAux  CBRACE
	| CLASS ID OBRACE CBRACE
	;

ProgramAux : FieldDecl
	| MethodDecl
	| SEMI
	| ProgramAux FieldDecl
	| ProgramAux MethodDecl
	| ProgramAux SEMI
	;


FieldDecl: PUBLIC STATIC Type ID FieldDeclAux SEMI
	| PUBLIC STATIC Type ID  SEMI
  | error SEMI
	;

FieldDeclAux
	: COMMA ID
	| FieldDeclAux COMMA ID
	;

MethodDecl: PUBLIC STATIC MethodHeader MethodBody ;

MethodHeader: Type ID OCURV CCURV
	| Type  ID OCURV FormalParams CCURV
	| VOID ID OCURV CCURV
	| VOID ID OCURV FormalParams CCURV
	;


MethodBody: OBRACE CBRACE
	| OBRACE MethodBodyAux CBRACE
	;


MethodBodyAux: VarDecl
	| Statement
	| MethodBodyAux VarDecl
	| MethodBodyAux Statement
	;


FormalParams: Type ID
	| Type ID FormalParamsAux
	| STRING OSQUARE CSQUARE ID
	;


FormalParamsAux
	: FormalParamsAux COMMA Type ID
	| COMMA Type ID
	;


VarDecl
	: Type ID FieldDeclAux SEMI
	| Type ID SEMI
	;

Type: BOOL
	| INT
	| DOUBLE
	;

Statement: OBRACE StatementAux CBRACE
  | OBRACE CBRACE
	| IF OCURV Expr CCURV Statement %prec NO_ELSE
	| IF OCURV Expr CCURV Statement ELSE Statement
	| WHILE OCURV Expr CCURV Statement
	| DO Statement WHILE OCURV Expr CCURV SEMI
	| PRINT OCURV Expr CCURV SEMI
	| PRINT OCURV STRLIT CCURV SEMI
	| SEMI
	| Assignment SEMI
  | Assignment ParseArgs SEMI
  | Assignment MethodInvocation SEMI
  | Assignment MethodInvocation ParseArgs SEMI
	| MethodInvocation SEMI
  | MethodInvocation ParseArgs SEMI
	| ParseArgs SEMI
	| RETURN  SEMI
	| RETURN  Expr SEMI
	| error SEMI
	;

StatementAux: Statement
	| StatementAux Statement
	;

Assignment: ID ASSIGN Expr ;

MethodInvocation: ID OCURV CCURV
  | ID OCURV Expr CCURV
	| ID OCURV Expr MethodInvocationAux CCURV
	| ID OCURV error CCURV
	;

MethodInvocationAux : COMMA Expr
	| MethodInvocationAux COMMA Expr
	;


ParseArgs: PARSEINT OCURV ID OSQUARE Expr CSQUARE CCURV
	| PARSEINT OCURV error CCURV
	;


Expr: Assignment
	| MethodInvocation
	| ParseArgs
	| Expr AND ExprAux
	| Expr OR ExprAux
	| Expr EQ ExprAux
	| Expr GT ExprAux
  | Expr GEQ ExprAux
	| Expr LEQ ExprAux
	| Expr LT ExprAux
	| Expr NEQ ExprAux
	| Expr PLUS ExprAux
	| Expr MINUS ExprAux
	| Expr STAR ExprAux
	| Expr DIV ExprAux
	| Expr MOD ExprAux
	| PLUS ExprAux
	| MINUS ExprAux
	| NOT ExprAux
	| ID
	| ID DOTLENGTH
	| OCURV Expr CCURV
	| BOOLLIT
	| DECLIT
	| REALLIT
	| OCURV error CCURV
	;

  ExprAux
  	: MethodInvocation
  	| ParseArgs
  	| ExprAux AND ExprAux
  	| ExprAux OR ExprAux
  	| ExprAux EQ ExprAux
  	| ExprAux GEQ ExprAux
  	| ExprAux GT ExprAux
  	| ExprAux LEQ ExprAux
  	| ExprAux LT ExprAux
  	| ExprAux NEQ ExprAux
  	| ExprAux PLUS ExprAux
  	| ExprAux STAR ExprAux
    | ExprAux MINUS ExprAux
  	| ExprAux DIV ExprAux
  	| ExprAux MOD ExprAux
    | PLUS ExprAux
  	| MINUS ExprAux
  	| NOT ExprAux
  	| ID
  	| ID DOTLENGTH
  	| OCURV ExprAux CCURV
  	| BOOLLIT
  	| DECLIT
  	| REALLIT
  	| OCURV error CCURV
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
