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
    INIT = 258,
    ID = 259,
    INT = 260,
    FLOAT = 261,
    VOID = 262,
    INTCONST = 263,
    FLOATCONST = 264,
    COMMA = 265,
    SCOL = 266,
    IF = 267,
    ELSE = 268,
    LOOP = 269,
    BREAK = 270,
    RETURN = 271,
    ASSGN = 272,
    ADD = 273,
    SUB = 274,
    MUL = 275,
    DIV = 276,
    LES = 277,
    LEQ = 278,
    GRE = 279,
    GEQ = 280,
    EQL = 281,
    NEQ = 282,
    LSBR = 283,
    RSBR = 284,
    LPBR = 285,
    RPBR = 286,
    LFBR = 287,
    RFBR = 288,
    ERR = 289
  };
#endif
/* Tokens.  */
#define INIT 258
#define ID 259
#define INT 260
#define FLOAT 261
#define VOID 262
#define INTCONST 263
#define FLOATCONST 264
#define COMMA 265
#define SCOL 266
#define IF 267
#define ELSE 268
#define LOOP 269
#define BREAK 270
#define RETURN 271
#define ASSGN 272
#define ADD 273
#define SUB 274
#define MUL 275
#define DIV 276
#define LES 277
#define LEQ 278
#define GRE 279
#define GEQ 280
#define EQL 281
#define NEQ 282
#define LSBR 283
#define RSBR 284
#define LPBR 285
#define RPBR 286
#define LFBR 287
#define RFBR 288
#define ERR 289

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 14 "parser.y" /* yacc.c:1909  */

	int ival;
	float fval; 
	char text[20];

#line 128 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
