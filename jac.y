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
  int syntax_flag = 0;


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

Program: CLASS ID OBRACE  ProgramAux  CBRACE                          {if(syntax_flag != 1){no_aux = new_node("Id",$2);root = new_node("Program",NULL);add_sibiling(no_aux,$4);add_child(root,no_aux);}}
	;

ProgramAux
	: ProgramAux FieldDecl                                              {if(syntax_flag != 1){add_sibiling($1,$2); $$ = $1;}}
	| ProgramAux MethodDecl                                             {if(syntax_flag != 1){add_sibiling($1,$2); $$ = $1;}}
	| ProgramAux SEMI                                                   {if(syntax_flag != 1){$$ = $1;}}
  | %empty                                                            {if(syntax_flag != 1){$$ = new_node("NULL",NULL);}}



  FieldDecl
  : PUBLIC STATIC Type ID FieldDeclAux SEMI                           {if(syntax_flag != 1){no_aux = new_node("FieldDecl",NULL); add_child(no_aux,$3); add_sibiling(no_aux->child_node,new_node("Id",$4)); add_sibiling(no_aux,$5); $$ = no_aux;}}
  | PUBLIC STATIC Type ID SEMI                                        {if(syntax_flag != 1){no_aux = new_node("FieldDecl",NULL); add_child(no_aux,$3); add_sibiling(no_aux->child_node,new_node("Id",$4)); $$ = no_aux;}}
  | error SEMI                                                        {$$ = NULL;}
	;

FieldDeclAux
	: COMMA ID FieldDeclAux                                              {if(syntax_flag != 1){no_aux = new_node("FieldDecl", NULL); add_child(no_aux,new_node(string_type,NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux,$3); $$ = no_aux;}}
  | COMMA ID                                                           {if(syntax_flag != 1){no_aux = new_node("FieldDecl", NULL); add_child(no_aux,new_node(string_type,NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); $$ = no_aux;}}
  ;
MethodDecl: PUBLIC STATIC MethodHeader MethodBody                     {if(syntax_flag != 1){no_aux = new_node("MethodDecl",NULL); add_child(no_aux,$3); add_sibiling($3,$4);  $$ = no_aux;}}
  ;
MethodHeader
  : Type ID OCURV CCURV                                               {if(syntax_flag != 1){no_aux = new_node("MethodHeader",NULL); add_child(no_aux,$1); add_sibiling(no_aux->child_node,new_node("Id",$2));add_sibiling($1,new_node("MethodParams",NULL)); $$ = no_aux;}}
	| Type ID OCURV FormalParams CCURV                                  {if(syntax_flag != 1){no_aux = new_node("MethodHeader",NULL); add_child(no_aux,$1); aux = new_node("MethodParams",NULL); add_sibiling(no_aux->child_node,new_node("Id",$2));add_sibiling($1,aux);add_child(aux,$4); $$ = no_aux;}}
	| VOID ID OCURV CCURV                                               {if(syntax_flag != 1){no_aux = new_node("MethodHeader", NULL); add_child(no_aux,new_node("Void",NULL));add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux->child_node,new_node("MethodParams",NULL));$$ = no_aux;}}
	| VOID ID OCURV FormalParams CCURV                                  {if(syntax_flag != 1){no_aux = new_node("MethodHeader",NULL); add_child(no_aux,new_node("Void",NULL)); aux = new_node("MethodParams",NULL); add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux->child_node,aux); add_child(aux,$4);$$ = no_aux;}}
	;


MethodBody
	: OBRACE MethodBodyAux CBRACE                                       {if(syntax_flag != 1){no_aux = new_node("MethodBody",NULL); add_child(no_aux,$2); $$ = no_aux;}}
	;


MethodBodyAux
	: MethodBodyAux VarDecl                                             {if(syntax_flag != 1){add_sibiling($1,$2); $$ = $1;}}
  | MethodBodyAux Statement                                           {if(syntax_flag != 1){add_sibiling($1,$2); $$ = $1;}}
  | %empty                                                            {if(syntax_flag != 1){$$ = new_node("NULL",NULL);}}
	;


FormalParams
	: Type ID FormalParamsAux                                           {if(syntax_flag != 1){no_aux = new_node("ParamDecl",NULL);add_child(no_aux,$1);add_sibiling($1,new_node("Id",$2));add_sibiling(no_aux,$3); $$ = no_aux;}}
	| STRING OSQUARE CSQUARE ID                                         {if(syntax_flag != 1){no_aux = new_node("ParamDecl",NULL);add_child(no_aux,new_node("StringArray",NULL)); add_sibiling(no_aux->child_node,new_node("Id",$4)); $$ = no_aux;}}
  | Type ID                                                           {if(syntax_flag != 1){no_aux = new_node("ParamDecl",NULL);add_child(no_aux,$1); add_sibiling($1,new_node("Id",$2)); $$ = no_aux; }}
  ;

FormalParamsAux
	: COMMA Type ID FormalParamsAux                                     {if(syntax_flag != 1){no_aux = new_node("ParamDecl",NULL); add_child(no_aux,$2); add_sibiling($2,new_node("Id",$3));add_sibiling(no_aux,$4); $$ = no_aux;}}
	| COMMA Type ID                                                     {if(syntax_flag != 1){no_aux = new_node("ParamDecl",NULL); add_child(no_aux,$2); add_sibiling($2,new_node("Id",$3)); $$ = no_aux;}}
	;


VarDecl
	: Type ID VarDeclAux SEMI                                          {if(syntax_flag != 1){no_aux = new_node("VarDecl",NULL); add_child(no_aux,$1);add_sibiling(no_aux->child_node,new_node("Id",$2)); add_sibiling(no_aux,$3);$$ = no_aux;}}
  | Type ID SEMI                                                     {if(syntax_flag != 1){no_aux = new_node("VarDecl",NULL); add_child(no_aux,$1); add_sibiling($1,new_node("Id",$2)); $$ = no_aux;}}
  ;
VarDeclAux
  : COMMA ID VarDeclAux                                              {if(syntax_flag != 1){no_aux = new_node("VarDecl",NULL); add_child(no_aux,new_node(string_type,NULL));add_sibiling(no_aux->child_node,new_node("Id",$2));add_sibiling(no_aux,$3);$$ = no_aux;}}
  | COMMA ID                                                         {if(syntax_flag != 1){no_aux = new_node("VarDecl",NULL); add_child(no_aux,new_node(string_type,NULL)); add_sibiling(no_aux->child_node,new_node("Id",$2)); $$ = no_aux;}}
  ;

Type: BOOL                                                           {if(syntax_flag != 1){$$ = new_node("Bool",NULL);strcpy(string_type,"Bool");}}
	| INT                                                              {if(syntax_flag != 1){$$ = new_node("Int",NULL);strcpy(string_type,"Int");}}
	| DOUBLE                                                           {if(syntax_flag != 1){$$ = new_node("Double",NULL);strcpy(string_type,"Double");}}
	;

Statement: OBRACE StatementAux CBRACE                                {if(syntax_flag != 1){if ($2 != NULL){if ($2->next_node != NULL){ no_aux = new_node("Block",NULL); add_child(no_aux,$2); $$ = no_aux;}else{$$ = $2;}}else{$$ = $2;}}}
  | OBRACE CBRACE                                                     {$$ = NULL;}
	| IF OCURV Expr CCURV Statement %prec NO_ELSE                       {if(syntax_flag != 1){
                                                                        no_aux = new_node("If",NULL);
                                                                        add_child(no_aux,$3);
                                                                        if ( $5 != NULL )
                                                                        {
                                                                          if ( $5->next_node != NULL )
                                                                          {
                                                                            aux = new_node("Block", NULL);
                                                                            add_sibiling($3,aux);
                                                                            add_child(aux,$5);
                                                                          }
                                                                          else
                                                                          {
                                                                            add_sibiling($3,$5);
                                                                          }
                                                                        }
                                                                        else
                                                                        {
                                                                          aux = new_node("Block",NULL);
                                                                          add_sibiling($3,aux);
                                                                        }
                                                                        $$ = no_aux;
                                                                      }}
	| IF OCURV Expr CCURV Statement ELSE Statement                      {if(syntax_flag != 1){
                                                                        no_aux = new_node("If",NULL); add_child(no_aux,$3);
                                                                        if ( $5 != NULL )
                                                                        {
                                                                          if ( $5->next_node != NULL )
                                                                          {
                                                                            aux = new_node("Block",NULL);
                                                                            add_sibiling($3,aux);
                                                                            add_child(aux,$5);
                                                                          }
                                                                          else
                                                                          {
                                                                            add_sibiling($3,$5);
                                                                          }
                                                                        }
                                                                        else
                                                                        {
                                                                          aux = new_node("Block",NULL);
                                                                          add_sibiling($3,aux);
                                                                        }

                                                                        if ( $7 != NULL )
                                                                        {
                                                                          if ( $7->next_node != NULL )
                                                                          {
                                                                            aux = new_node("Block",NULL);
                                                                            add_sibiling($3,aux);
                                                                            add_child(aux,$7);
                                                                          }
                                                                          else
                                                                          {
                                                                            add_sibiling($3,$7);
                                                                          }
                                                                        }
                                                                        else
                                                                        {
                                                                          aux = new_node("Block",NULL);
                                                                          add_sibiling($3,aux);
                                                                        }

                                                                        $$ = no_aux;
                                                                      }
                                                                    }
	| WHILE OCURV Expr CCURV Statement                                  {if(syntax_flag != 1){
                                                                        no_aux = new_node("While",NULL);add_child(no_aux,$3);
                                                                        if ( $5 != NULL)
                                                                        {

                                                                          if ($5->next_node != NULL)
                                                                          {
                                                                            aux = new_node("Block",NULL);
                                                                            add_child(aux,$5);
                                                                            add_sibiling($3,aux);
                                                                          }
                                                                          else
                                                                          {
                                                                            add_sibiling($3,$5);
                                                                          }
                                                                        }
                                                                        else
                                                                        {
                                                                          aux = new_node("Block",NULL);
                                                                          add_sibiling($3,aux);
                                                                        }
                                                                        $$ = no_aux;
                                                                      }
                                                                    }
	| DO Statement WHILE OCURV Expr CCURV SEMI                          {if(syntax_flag != 1){
                                                                        no_aux = new_node("DoWhile",NULL);
                                                                        if ($2 != NULL )
                                                                        {
                                                                          if ( $2->next_node != NULL )
                                                                          {
                                                                            aux = new_node("Block",NULL);
                                                                            add_child(aux,$2);
                                                                            add_sibiling($5,aux);
                                                                            add_child(no_aux,aux);
                                                                          }
                                                                          else
                                                                          {
                                                                            add_sibiling($2,$5);
                                                                            add_child(no_aux,$2);
                                                                          }
                                                                        }
                                                                        else
                                                                        {
                                                                          aux = new_node("Block",NULL);
                                                                          add_sibiling(aux,$5);
                                                                          add_child(no_aux,aux);
                                                                        }
                                                                        $$ = no_aux;
                                                                      }
                                                                    }
	| PRINT OCURV Expr CCURV SEMI                                       {if(syntax_flag != 1){no_aux = new_node("Print",NULL); add_child(no_aux,$3); $$ = no_aux; }}
	| PRINT OCURV STRLIT CCURV SEMI                                     {if(syntax_flag != 1){no_aux = new_node("Print",NULL); add_child(no_aux, new_node("StrLit",NULL)); $$ = no_aux;}}
	| SEMI                                                              {if(syntax_flag != 1){$$ = NULL;}}
	| Assignment SEMI                                                   {if(syntax_flag != 1){$$ = $1;}}
	| ParseArgs SEMI                                                    {if(syntax_flag != 1){$$ = $1;}}
  | MethodInvocation SEMI                                             {if(syntax_flag != 1){$$ = $1;}}
	| RETURN  SEMI                                                      {if(syntax_flag != 1){$$ = new_node("Return",NULL);}}
	| RETURN  Expr SEMI                                                 {if(syntax_flag != 1){$$ = new_node("Return",NULL); add_child($$,$2);}}
	| error SEMI                                                        {$$ = NULL;}
	;

StatementAux
	: StatementAux Statement                                            {if(syntax_flag != 1){if ( $1 != NULL){
                                                                            $$ = $1;
                                                                            add_sibiling($$,$2);
                                                                      }else{
                                                                          $$ = $2;
                                                                      }}
                                                                      }
  | Statement                                                         {if(syntax_flag != 1){$$ = $1;}}
  ;

Assignment: ID ASSIGN Expr                                            {if(syntax_flag != 1){no_aux = new_node("Assign",NULL); add_child(no_aux,new_node("Id",$1)); add_sibiling(no_aux->child_node,$3); $$ = no_aux;}}
  ;

MethodInvocation: ID OCURV CCURV                                      {if(syntax_flag != 1){no_aux = new_node("Call",NULL); add_child(no_aux,new_node("Id",$1)); $$ = no_aux;}}
	| ID OCURV Expr MethodInvocationAux CCURV                           {if(syntax_flag != 1){no_aux = new_node("Call",NULL); add_child(no_aux,new_node("Id",$1)); add_sibiling(no_aux->child_node,$3); add_sibiling(no_aux->child_node,$4); $$ = no_aux;}}
	| ID OCURV error CCURV                                              { $$ = NULL;}
	;

MethodInvocationAux
	: MethodInvocationAux COMMA Expr                                    {if(syntax_flag != 1){add_sibiling($1,$3);$$ = $1;}}
  | %empty                                                            {if(syntax_flag != 1){$$ = new_node("NULL",NULL);}}
	;


ParseArgs: PARSEINT OCURV ID OSQUARE Expr CSQUARE CCURV                    {if(syntax_flag != 1){no_aux = new_node("ParseArgs",NULL); add_child(no_aux,new_node("Id",$3)); add_sibiling(no_aux->child_node,$5); $$ = no_aux;}}
	| PARSEINT OCURV error CCURV                                             {$$ = NULL;}
	;


Expr: Assignment                                                           {if(syntax_flag != 1){$$ = $1;}}
	| ExprAux                                                                {if(syntax_flag != 1){$$ = $1;}}
	;

  ExprAux
  : MethodInvocation                                                       {if(syntax_flag != 1){$$ = $1;}}
  	| ParseArgs                                                            {if(syntax_flag != 1){$$ = $1;}}
  	| ExprAux AND ExprAux                                                  {if(syntax_flag != 1){no_aux = new_node("And",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux OR ExprAux                                                   {if(syntax_flag != 1){no_aux = new_node("Or",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux EQ ExprAux                                                   {if(syntax_flag != 1){no_aux = new_node("Eq",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
    | ExprAux GEQ ExprAux                                                  {if(syntax_flag != 1){no_aux = new_node("Geq",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
    | ExprAux GT ExprAux                                                   {if(syntax_flag != 1){no_aux = new_node("Gt",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux LEQ ExprAux                                                  {if(syntax_flag != 1){no_aux = new_node("Leq",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux LT ExprAux                                                   {if(syntax_flag != 1){no_aux = new_node("Lt",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux NEQ ExprAux                                                  {if(syntax_flag != 1){no_aux = new_node("Neq",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux PLUS ExprAux                                                 {if(syntax_flag != 1){no_aux = new_node("Add",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
    | ExprAux STAR ExprAux                                                 {if(syntax_flag != 1){no_aux = new_node("Mul",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
    | ExprAux MINUS ExprAux                                                {if(syntax_flag != 1){no_aux = new_node("Sub",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux DIV ExprAux                                                  {if(syntax_flag != 1){no_aux = new_node("Div",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
  	| ExprAux MOD ExprAux                                                  {if(syntax_flag != 1){no_aux = new_node("Mod",NULL); add_child(no_aux,$1); add_sibiling($1,$3); $$ = no_aux;}}
    | PLUS ExprAux                                                         {if(syntax_flag != 1){no_aux = new_node("Plus",NULL); add_child(no_aux,$2); $$ = no_aux;}}
  	| MINUS ExprAux                                                        {if(syntax_flag != 1){no_aux = new_node("Minus",NULL); add_child(no_aux,$2); $$ = no_aux;}}
  	| NOT ExprAux                                                          {if(syntax_flag != 1){no_aux = new_node("Not",NULL); add_child(no_aux,$2); $$ = no_aux;}}
  	| ID                                                                   {if(syntax_flag != 1){no_aux = new_node("Id",$1); $$ = no_aux;}}
  	| ID DOTLENGTH                                                         {if(syntax_flag != 1){no_aux = new_node("Length",NULL); add_child(no_aux,new_node("Id",$1)); $$ = no_aux;}}
  	| OCURV ExprAux CCURV                                                  {if(syntax_flag != 1){$$ = $2;}}
  	| BOOLLIT                                                              {if(syntax_flag != 1){no_aux = new_node("BoolLit",$1); $$ = no_aux;}}
  	| DECLIT                                                               {if(syntax_flag != 1){no_aux = new_node("DecLit",$1); $$ = no_aux;}}
  	| REALLIT                                                              {if(syntax_flag != 1){no_aux = new_node("RealLit",$1); $$ = no_aux;}}
  	| OCURV error CCURV                                                    {$$ = NULL;}
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
    syntax_flag = 1;
		printf("Line %d, col %d: %s: %s\n", n_lines, (int)(n_column - strlen(yytext)), s, yytext);
  }
}
