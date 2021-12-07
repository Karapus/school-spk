%language "c++"
%require "3.2"

%code requires {
	#include "ast.hh"
	using namespace AST;
}

%define api.token.raw
%define api.value.type { INode * }
%parse-param {yy::parser::semantic_type &ast}

%code provides {
	#define YYSTYPE yy::parser::semantic_type
}

%code {
	// Give Flex the prototype of yylex we want ...
	#define YY_DECL \
		yy::parser::token::yytokentype yylex(yy::parser::semantic_type *yylval)
	// ... and declare it for the parser's sake.
	YY_DECL;
}

%define parse.error verbose
%define parse.lac full

%define api.token.prefix {TOK_}
%token
	PLUS
	LPAR
	RPAR
	NUM
	ID
	SEMI
	LBRC
	RBRC
	EQLS
%nterm expr

%left SEMI
%precedence EQLS
%left PLUS
%start program
%%
program: expr SEMI	{ ast = new Scope{$1}; }
;

expr:	expr PLUS expr	{ $$ = new BinOp{std::plus<ValT>(), $1, $3}; }
    |	expr SEMI expr	{ $$ = new BinOp{[](auto lhs, auto rhs){ return rhs; }, $1, $3}; }
    |	ID EQLS expr	{ $$ = new Assign{$1, $3}; }
    |	LPAR expr RPAR	{ $$ = $2; }
    |	NUM		{ $$ = $1; }
    |	ID		{ $$ = $1; }
    |	LBRC expr RBRC	{ $$ = new Scope{$2}; }
;

%%

void yy::parser::error(const std::string &err_message) {
	std::cerr << "Error: " << err_message << std::endl;
}
