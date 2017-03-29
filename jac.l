%{

#include "y.tab.h"
#include <string.h>
  	extern int n_lines;
		extern int n_column;
		int st_line = 0;
		int st_column = 0;
		extern int flag;
    extern int parse;
#define RETURN_TOKEN(x) {yylval.token = strdup(yytext);return x;}
%}
LINE								            ("\n"|"\r"|"\r\n")
SPACE								            (" "|"\t"|"\f")
ID                          		(_|$|[a-z]|[A-Z])(_|$|[a-z]|[A-Z]|[0-9])*
DECLIT                      		0|[1-9]+(([0-9]|_)*[0-9]+)?
R_INT                       		[0-9]+(([0-9]|_)*[0-9]+)?
R_EXP                       		[eE][+-]?{R_INT}
REALLIT                     		({R_INT}\.({R_INT}?|{R_EXP}?))|(\.{R_INT}{R_EXP}?)|({R_INT}{R_EXP})|(({R_INT})\.{R_INT}{R_EXP})
STRLIT								          \"([^\\\n""\"""\r"]|{ESCAPE})*\"
ESCAPE				        		      \\f|\\n|\\r|\\t|\\\\|\\\"
BOOL                        		"boolean"
BOOLLIT                      		"true"|"false"
CLASS                       		"class"
DO                          		"do"
DOTLENGTH                   		".length"
DOUBLE                      		"double"
ELSE                       			"else"
IF                          		"if"
INT                        		 	"int"
PARSEINT                    		"Integer.parseInt"
PRINT                       		"System.out.println"
PUBLIC                      		"public"
RETURN                      		"return"
STATIC                      		"static"
STRING                      		"String"
VOID                        		"void"
WHILE                       		"while"
OCURV                       		"("
CCURV                       		")"
OBRACE                      		"{"
CBRACE                      		"}"
OSQUARE                     		"["
CSQUARE                     		"]"
AND                         		"&&"
OR                          		"||"
LT                          		"<"
GT                          		">"
EQ                          		"=="
NEQ                         		"!="
LEQ                         		"<="
GEQ                         		">="
PLUS                        		"+"
MINUS                       		"-"
STAR                        		"*"
DIV                        			"/"
MOD                        			"%"
NOT                         		"!"
ASSIGN                      		"="
SEMI                       			";"
COMMA                       		","
RESERVED                   			"++"|"--"|"null"|"Integer"|"System"|"abstract"|"assert"|"break"|"byte"|"case"|"catch"|"char"|"continue"|"const"|"default"|"enum"|"extends"|"final"|"finally"|"float"|"for"|"goto"|"implements"|"import"|"instanceof"|"interface"|"long"|"native"|"new"|"package"|"private"|"protected"|"short"|"strictfp"|"super"|"switch"|"synchronized"|"this"|"throw"|"throws"|"transient"|"try"|"volatile"
%X COMMENT_B
%X COMMENT
%X STRING_ESCAPE
ILLEGAL								.

%%
{LINE}								        {n_column = 1;n_lines++;}
{SPACE}								        {n_column+=yyleng;}
{BOOL}				              	{n_column+=yyleng; if (flag == 1){printf("BOOL\n");} if( parse == -1 ){RETURN_TOKEN(BOOL);};}
{BOOLLIT}			           		  {n_column+=yyleng; if (flag == 1){printf("BOOLLIT(%s)\n",yytext);} if( parse == -1 ){RETURN_TOKEN(BOOLLIT);};}
{CLASS}			              		{n_column+=yyleng; if (flag == 1){printf("CLASS\n");}  if( parse == -1 ){RETURN_TOKEN(CLASS);};}
{DO}				             	    {n_column+=yyleng; if (flag == 1){printf("DO\n");}  if( parse == -1 ){RETURN_TOKEN(DO);};}
{DOTLENGTH}			           		{n_column+=yyleng; if (flag == 1){printf("DOTLENGTH\n");}  if( parse == -1 ){RETURN_TOKEN(DOTLENGTH);};}
{DOUBLE}			             	  {n_column+=yyleng; if (flag == 1){printf("DOUBLE\n");}  if( parse == -1 ){RETURN_TOKEN(DOUBLE);};}
{ELSE}				              	{n_column+=yyleng; if (flag == 1){printf("ELSE\n");}if( parse == -1 ){RETURN_TOKEN(ELSE);};}
{IF}				              	  {n_column+=yyleng; if (flag == 1){printf("IF\n");}if( parse == -1 ){RETURN_TOKEN(IF);};}
{INT}				              	  {n_column+=yyleng; if (flag == 1){printf("INT\n");} if( parse == -1 ){RETURN_TOKEN(INT);};}
{PARSEINT}			           		{n_column+=yyleng; if (flag == 1){printf("PARSEINT\n");} if( parse == -1 ) {RETURN_TOKEN(PARSEINT);};}
{PRINT}				             	  {n_column+=yyleng; if (flag == 1){printf("PRINT\n");} if( parse == -1 ) {RETURN_TOKEN(PRINT);};}
{PUBLIC}			             	  {n_column+=yyleng; if (flag == 1){printf("PUBLIC\n");} if( parse == -1 ) {RETURN_TOKEN(PUBLIC);};}
{RETURN}			             	  {n_column+=yyleng; if (flag == 1){printf("RETURN\n");} if( parse == -1 ) {RETURN_TOKEN(RETURN);};}
{STATIC}			             	  {n_column+=yyleng; if (flag == 1){printf("STATIC\n");} if( parse == -1 ) {RETURN_TOKEN(STATIC);};}
{STRING}			             	  {n_column+=yyleng; if (flag == 1){printf("STRING\n");} if( parse == -1 ) {RETURN_TOKEN(STRING);};}
{VOID}				             	  {n_column+=yyleng; if (flag == 1){printf("VOID\n");}  if( parse == -1 ){RETURN_TOKEN(VOID);};}
{WHILE}				             	  {n_column+=yyleng; if (flag == 1){printf("WHILE\n");}  if( parse == -1 ){RETURN_TOKEN(WHILE);};}
{OCURV}				             	  {n_column+=yyleng; if (flag == 1){printf("OCURV\n");}  if( parse == -1 ){RETURN_TOKEN(OCURV);};}
{CCURV}				             	  {n_column+=yyleng; if (flag == 1){printf("CCURV\n");}  if( parse == -1 ){RETURN_TOKEN(CCURV);};}
{OBRACE}			             	  {n_column+=yyleng; if (flag == 1){printf("OBRACE\n");}  if( parse == -1 ){RETURN_TOKEN(OBRACE);};}
{CBRACE}			             	  {n_column+=yyleng; if (flag == 1){printf("CBRACE\n");}  if( parse == -1 ){RETURN_TOKEN(CBRACE);};}
{OSQUARE}			             	  {n_column+=yyleng; if (flag == 1){printf("OSQUARE\n");}  if( parse == -1 ){RETURN_TOKEN(OSQUARE);};}
{CSQUARE}			             	  {n_column+=yyleng; if (flag == 1){printf("CSQUARE\n");}  if( parse == -1 ){RETURN_TOKEN(CSQUARE);};}
{AND}				                  {n_column+=yyleng; if (flag == 1){printf("AND\n");}  if( parse == -1 ){RETURN_TOKEN(AND);};}
{OR}				                  {n_column+=yyleng; if (flag == 1){printf("OR\n");}  if( parse == -1 ){RETURN_TOKEN(OR);};}
{LT}				                  {n_column+=yyleng; if (flag == 1){printf("LT\n");}  if( parse == -1 ){RETURN_TOKEN(LT);};}
{GT}				                  {n_column+=yyleng; if (flag == 1){printf("GT\n");}  if( parse == -1 ){RETURN_TOKEN(GT);};}
{EQ}				                  {n_column+=yyleng; if (flag == 1){printf("EQ\n");}  if( parse == -1 ){RETURN_TOKEN(EQ);};}
{NEQ}				                  {n_column+=yyleng; if (flag == 1){printf("NEQ\n");}  if( parse == -1 ){RETURN_TOKEN(NEQ);};}
{LEQ}				                  {n_column+=yyleng; if (flag == 1){printf("LEQ\n");}  if( parse == -1 ){RETURN_TOKEN(LEQ);};}
{GEQ}				                  {n_column+=yyleng; if (flag == 1){printf("GEQ\n");}  if( parse == -1 ){RETURN_TOKEN(GEQ);};}
{PLUS}			              		{n_column+=yyleng; if (flag == 1){printf("PLUS\n");}  if( parse == -1 ){RETURN_TOKEN(PLUS);};}
{MINUS}			              		{n_column+=yyleng; if (flag == 1){printf("MINUS\n");}  if( parse == -1 ){RETURN_TOKEN(MINUS);};}
{STAR}			              		{n_column+=yyleng; if (flag == 1){printf("STAR\n");}  if( parse == -1 ){RETURN_TOKEN(STAR);};}
{DIV}				                  {n_column+=yyleng; if (flag == 1){printf("DIV\n");}  if( parse == -1 ){RETURN_TOKEN(DIV);};}
{MOD}				                  {n_column+=yyleng; if (flag == 1){printf("MOD\n");}  if( parse == -1 ){RETURN_TOKEN(MOD);};}
{NOT}				                  {n_column+=yyleng; if (flag == 1){printf("NOT\n");}  if( parse == -1 ){RETURN_TOKEN(NOT);};}
{ASSIGN} 		              		{n_column+=yyleng; if (flag == 1){printf("ASSIGN\n");}  if( parse == -1 ){RETURN_TOKEN(ASSIGN);};}
{SEMI}				             	  {n_column+=yyleng; if (flag == 1){printf("SEMI\n");}  if( parse == -1 ){RETURN_TOKEN(SEMI);};}
{COMMA}				             	  {n_column+=yyleng; if (flag == 1){printf("COMMA\n");}  if( parse == -1 ){RETURN_TOKEN(COMMA);};}
{RESERVED}			           		{n_column+=yyleng; if (flag == 1){printf("RESERVED(%s)\n",yytext);}  if( parse == -1 ){RETURN_TOKEN(RESERVED);};}
{ID}                     			{n_column+=yyleng; if (flag == 1){printf("ID(%s)\n",yytext);}  if( parse == -1 ){RETURN_TOKEN(ID);};}
{REALLIT}                   	{n_column+=yyleng; if (flag == 1){printf("REALLIT(%s)\n",yytext);} if( parse == -1 ) {RETURN_TOKEN(REALLIT);};}
{DECLIT}                 			{n_column+=yyleng; if (flag == 1){printf("DECLIT(%s)\n",yytext);}  if( parse == -1 ){RETURN_TOKEN(DECLIT);};}
{STRLIT}                    	{n_column+=yyleng; if (flag == 1){printf("STRLIT(%s)\n",yytext);}  if( parse == -1 ){RETURN_TOKEN(STRLIT);};}

"/*"								          {BEGIN COMMENT;st_line = n_lines;st_column = n_column;n_column+=yyleng;}
<COMMENT>("\r"|"\n"|"\r\n")		{n_column = 1;n_lines++;}
<COMMENT>"*/"						      {BEGIN 0;n_column+=yyleng;}
<COMMENT>.							      {n_column+=yyleng;}
<COMMENT><<EOF>>					    {printf("Line %d, col %d: unterminated comment\n",st_line,st_column);BEGIN 0;}

"//"								          {BEGIN COMMENT_B;n_column+=yyleng;}
<COMMENT_B>("\r"|"\n"|"\r\n") {BEGIN 0;n_column = 1;n_lines++;}
<COMMENT_B><<EOF>>         		{BEGIN 0;}
<COMMENT_B>.                	{n_column+=yyleng;}


\"									          {BEGIN STRING_ESCAPE;st_line = n_lines;st_column = n_column;n_column+=yyleng;}
<STRING_ESCAPE>{ESCAPE}				{n_column+=yyleng;}
<STRING_ESCAPE>\"					    {BEGIN 0 ;n_column+=yyleng;}
<STRING_ESCAPE>(\\.|\\)				{printf("Line %d, col %d: invalid escape sequence (%s)\n",n_lines,n_column,yytext);n_column+=yyleng;BEGIN STRING_ESCAPE;}
<STRING_ESCAPE>{LINE}     		{printf("Line %d, col %d: unterminated string literal\n", n_lines, st_column);n_lines++;n_column=1;BEGIN 0;}
<STRING_ESCAPE><<EOF>>        {printf("Line %d, col %d: unterminated string literal\n", n_lines, n_column);BEGIN 0;}
<STRING_ESCAPE>.            	{n_column+=yyleng;}


{ILLEGAL}							        {printf("Line %d, col %d: illegal character (%s)\n",n_lines,n_column,yytext);n_column+=yyleng;}


%%

int yywrap()
{
return 1;
}
