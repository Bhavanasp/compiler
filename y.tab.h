/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NOELSE = 258,
    ELSE = 259,
    INIT = 260,
    INT = 261,
    FLOAT = 262,
    VOID = 263,
    INTCONST = 264,
    FLOATCONST = 265,
    ID = 266,
    COMMA = 267,
    SCOL = 268,
    IF = 269,
    LOOP = 270,
    BREAK = 271,
    RETURN = 272,
    ASSGN = 273,
    PLUS = 274,
    MINUS = 275,
    MUL = 276,
    DIV = 277,
    LES = 278,
    LEQ = 279,
    GRE = 280,
    GEQ = 281,
    EQL = 282,
    NEQ = 283,
    AND = 284,
    OR = 285,
    NOT = 286,
    LSBR = 287,
    RSBR = 288,
    LPBR = 289,
    RPBR = 290,
    LFBR = 291,
    RFBR = 292,
    ERR = 293
  };
#endif
/* Tokens.  */
#define NOELSE 258
#define ELSE 259
#define INIT 260
#define INT 261
#define FLOAT 262
#define VOID 263
#define INTCONST 264
#define FLOATCONST 265
#define ID 266
#define COMMA 267
#define SCOL 268
#define IF 269
#define LOOP 270
#define BREAK 271
#define RETURN 272
#define ASSGN 273
#define PLUS 274
#define MINUS 275
#define MUL 276
#define DIV 277
#define LES 278
#define LEQ 279
#define GRE 280
#define GEQ 281
#define EQL 282
#define NEQ 283
#define AND 284
#define OR 285
#define NOT 286
#define LSBR 287
#define RSBR 288
#define LPBR 289
#define RPBR 290
#define LFBR 291
#define RFBR 292
#define ERR 293

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 40 "parser.y" /* yacc.c:1909  */

	int ival;
	float fval; 
	char text[20];
	struct ast_node* snode;

#line 137 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
