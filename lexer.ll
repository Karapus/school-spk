%option noyywrap bison-bridge nounput
%{
	#include "grammar.tab.hh"
	#include "ast.hh"
	#include <string>
	#define YY_TERMINATE return 
%}
%x comment

wc	[ \t\r]
num	([1-9][0-9]*)|"0"

%%

"//"		BEGIN(comment);
<comment>[^\n]*
<comment>\n	BEGIN(INITIAL);

{wc}+
"+"		return yy::parser::token::TOK_PLUS;
"("		return yy::parser::token::TOK_LPAR;
")"		return yy::parser::token::TOK_RPAR;
";"		return yy::parser::token::TOK_SEMI;
"="		return yy::parser::token::TOK_EQLS;
"{"		return yy::parser::token::TOK_LBRC;
"}"		return yy::parser::token::TOK_RBRC;
{num}	{
		*yylval = new AST::ImVal{std::stoi(yytext)};
		return yy::parser::token::TOK_NUM;
	}
[a-zA-Z]+ {
		*yylval = new AST::Id{yytext};
		return yy::parser::token::TOK_ID;
	}
.	throw yy::parser::syntax_error("invalid character: " + std::string(yytext));
%%
