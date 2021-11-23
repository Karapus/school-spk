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
{num}	{
		*yylval = new AST::ImVal{std::stoi(yytext)};
		return yy::parser::token::TOK_NUM;
	}
.	throw yy::parser::syntax_error("invalid character: " + std::string(yytext));
%%
