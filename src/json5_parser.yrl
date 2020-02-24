Nonterminals value array array_elems object object_data object_key.
Terminals '{' '}' '[' ']' ':' ',' number sq_string dq_string null comment boolean identifier.
Rootsymbol value.
  
object -> '{' '}' : #{}.
object -> '{' object_data '}' : '$2'.

object_data -> object_key ':' value : #{'$1' => '$3'}.
object_data -> object_key ':' value ',' object_data : maps:put('$1', '$3', '$5').

object_key -> identifier : extract_token('$1').
object_key -> sq_string : extract_token('$1').
object_key -> dq_string : extract_token('$1').

array -> '[' ']'       : [].
array -> '[' array_elems ']' : '$2'.

array_elems -> value           : ['$1'].
array_elems -> value ',' array_elems : ['$1'|'$3'].

value -> comment value : '$2'.
value -> number  : extract_token('$1').
value -> sq_string : extract_token('$1').
value -> dq_string : extract_token('$1').
value -> null : extract_token('$1').
value -> boolean : extract_token('$1').
value -> array : '$1'.
value -> object : '$1'.

Erlang code.

extract_token({null, _Line}) -> nil;
extract_token({boolean, _Line, Value}) -> erlang:list_to_atom(Value);
extract_token({number, _Line, Value}) -> erlang:list_to_integer(Value);
extract_token({identifier, _Line, Value}) -> erlang:list_to_binary(Value);
extract_token({dq_string, _Line, Value}) -> string:trim(erlang:list_to_binary(Value), both, "\"");
extract_token({sq_string, _Line, Value}) -> string:trim(erlang:list_to_binary(Value), both, "'");
extract_token({_Token, _Line, Value}) -> Value.