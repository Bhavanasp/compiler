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
    CHAR = 263,
    VOID = 264,
    INTCONST = 265,
    FLOATCONST = 266,
    CHARCONST = 267,
    ID = 268,
    COMMA = 269,
    SCOL = 270,
    IF = 271,
    LOOP = 272,
    BREAK = 273,
    RETURN = 274,
    ASSGN = 275,
    PLUS = 276,
    MINUS = 277,
    MUL = 278,
    DIV = 279,
    LES = 280,
    LEQ = 281,
    GRE = 282,
    GEQ = 283,
    EQL = 284,
    NEQ = 285,
    AND = 286,
    OR = 287,
    NOT = 288,
    LSBR = 289,
    RSBR = 290,
    LPBR = 291,
    RPBR = 292,
    LFBR = 293,
    RFBR = 294,
    ERR = 295
  };
#endif
/* Tokens.  */
#define NOELSE 258
#define ELSE 259
#define INIT 260
#define INT 261
#define FLOAT 262
#define CHAR 263
#define VOID 264
#define INTCONST 265
#define FLOATCONST 266
#define CHARCONST 267
#define ID 268
#define COMMA 269
#define SCOL 270
#define IF 271
#define LOOP 272
#define BREAK 273
#define RETURN 274
#define ASSGN 275
#define PLUS 276
#define MINUS 277
#define MUL 278
#define DIV 279
#define LES 280
#define LEQ 281
#define GRE 282
#define GEQ 283
#define EQL 284
#define NEQ 285
#define AND 286
#define OR 287
#define NOT 288
#define LSBR 289
#define RSBR 290
#define LPBR 291
#define RPBR 292
#define LFBR 293
#define RFBR 294
#define ERR 295

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 43 "parser.y" /* yacc.c:1909  */

	int ival;
	float fval; 
	char text[20];
	struct ast_node* snode;

#line 141 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
