%language "c++"
%require "3.2"

%define api.token.raw
%define api.value.type { int }
%parse-param {int &val}
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
%nterm expr

//%left PLUS

%start program
%%
program: expr		{ val = $1; }
;

expr:	expr PLUS expr	{ $$ = $1 + $3; }
    |	LPAR expr RPAR	{ $$ = $2; }
    |	NUM		{ $$ = $1; }
;

%%

void yy::parser::error(const std::string &err_message) {
	std::cerr << "Error: " << err_message << std::endl;
}
