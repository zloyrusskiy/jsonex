Definitions.

DIGIT = [0-9]
DIGIT1to9 = [1-9]
DIGITS = {DIGIT}+
INT = ({DIGIT}|{DIGIT1to9}{DIGITS})
FRAC = \.{DIGITS}
TRAILING_FRAC = {INT}\.
FLOATING = {INT}{FRAC}
EXP = [eE][\+\-]?{DIGITS}
HEX_DIGIT = [0-9a-f]
HEX_NUMBER = 0[xX]{HEX_DIGIT}+
OCT_NUMBER = 0{DIGITS}+
NUMBER_INFINITY = Infinity
NUMBER_NAN = NaN
NUMBER = ({INT}{EXP}|{FLOATING}{EXP}|{FLOATING}|{NUMBER_INFINITY}|{NUMBER_NAN}|{HEX_NUMBER}|{OCT_NUMBER}|{TRAILING_FRAC}|{INT}|{FRAC})
NUMBER_WITH_SIGN = [\-\+]?{NUMBER}
UNICODE_ESCAPE_SEQUENCE = \\u{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}
IDENTIFIER = ([\$\_a-zA-Z]|{UNICODE_ESCAPE_SEQUENCE})+
ESCAPEDCHAR = \\.
SINGLE_QUOTE = '
SINGLE_QUOTED_CHAR = ({ESCAPEDCHAR}|[^{SINGLE_QUOTE}])
DOUBLE_QUOTE = "
DOUBLE_QUOTED_CHAR = ({ESCAPEDCHAR}|[^{DOUBLE_QUOTE}])
WHITESPACE = [\s\t\n\r]
SINGLE_LINE_COMMENT = //[^\n]+
MULTI_LINE_COMMENT = /\*(.|\n)+\*/
SINGLE_QUOTE_STRING = ({SINGLE_QUOTE}{SINGLE_QUOTE}|{SINGLE_QUOTE}{SINGLE_QUOTED_CHAR}+{SINGLE_QUOTE})
DOUBLE_QUOTE_STRING = ({DOUBLE_QUOTE}{DOUBLE_QUOTE}|{DOUBLE_QUOTE}{DOUBLE_QUOTED_CHAR}+{DOUBLE_QUOTE})
BOOLEAN = (true|false)

Rules.

{SINGLE_QUOTE_STRING} : {token, {sq_string, TokenLine, TokenChars}}.
{DOUBLE_QUOTE_STRING} : {token, {dq_string, TokenLine, TokenChars}}.
{NUMBER_WITH_SIGN} : {token, {number, TokenLine, TokenChars}}.
{SINGLE_LINE_COMMENT} : {token, {comment, TokenLine, TokenChars}}.
{MULTI_LINE_COMMENT} : {token, {comment, TokenLine, TokenChars}}.
null : {token, {null, TokenLine}}.
{BOOLEAN} : {token, {boolean, TokenLine, TokenChars}}.
{IDENTIFIER} : {token, {identifier, TokenLine, TokenChars}}.
\[ : {token, {'[', TokenLine}}.
\] : {token, {']', TokenLine}}.
\{ : {token, {'{', TokenLine}}.
\} : {token, {'}', TokenLine}}.
, : {token, {',', TokenLine}}.
\: : {token, {':', TokenLine}}.
{WHITESPACE}+ : skip_token.

Erlang code.
