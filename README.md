Meta 2 Compiladores
Gramática e Arvore

Compilação:
  - lex jac.l
  - yacc -d jac.y
  - cc -o jac y.tab.c lex.yy.c
