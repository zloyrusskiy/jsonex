defmodule JSON5LexerTest do
  use ExUnit.Case

  test "null" do
    assert :json5_lexer.string('null') == {:ok, [{:null, 1}], 1}
  end

  test "boolean" do
    assert :json5_lexer.string('true') == {:ok, [{:boolean, 1, 'true'}], 1}
    assert :json5_lexer.string('false') == {:ok, [{:boolean, 1, 'false'}], 1}
  end

  describe "string" do
    test "empty string" do
      assert :json5_lexer.string('""') == {:ok, [{:dq_string, 1, '""'}], 1}
      assert :json5_lexer.string('\'\'') == {:ok, [{:sq_string, 1, '\'\''}], 1}
    end

    test "sq string" do
      assert :json5_lexer.string('\'test\'') == {:ok, [{:sq_string, 1, '\'test\''}], 1}
    end

    test "dq string" do
      assert :json5_lexer.string('"test"') == {:ok, [{:dq_string, 1, '"test"'}], 1}
    end

    test "escaped symbols" do
      assert :json5_lexer.string('"test\\""') == {:ok, [{:dq_string, 1, '"test\\""'}], 1}
      assert :json5_lexer.string('\'test\\\'\'') == {:ok, [{:sq_string, 1, '\'test\\\'\''}], 1}
    end

    test "multiline string" do
      assert :json5_lexer.string("\"a \\\n b\"" |> to_charlist) ==
               {:ok, [{:dq_string, 1, '"a \\\n b"'}], 2}

      assert :json5_lexer.string("\'a \\\n b\'" |> to_charlist) ==
               {:ok, [{:sq_string, 1, '\'a \\\n b\''}], 2}
    end
  end

  describe "number" do
    test "infinity" do
      assert :json5_lexer.string('Infinity') == {:ok, [{:number, 1, 'Infinity'}], 1}
      assert :json5_lexer.string('+Infinity') == {:ok, [{:number, 1, '+Infinity'}], 1}
      assert :json5_lexer.string('-Infinity') == {:ok, [{:number, 1, '-Infinity'}], 1}
    end

    test "nan" do
      assert :json5_lexer.string('NaN') == {:ok, [{:number, 1, 'NaN'}], 1}
      assert :json5_lexer.string('+NaN') == {:ok, [{:number, 1, '+NaN'}], 1}
      assert :json5_lexer.string('-NaN') == {:ok, [{:number, 1, '-NaN'}], 1}
    end

    test "integer number" do
      assert :json5_lexer.string('123') == {:ok, [{:number, 1, '123'}], 1}
      assert :json5_lexer.string('+123') == {:ok, [{:number, 1, '+123'}], 1}
      assert :json5_lexer.string('-123') == {:ok, [{:number, 1, '-123'}], 1}
    end

    test "withFractionPart" do
      assert :json5_lexer.string('1.23') == {:ok, [{:number, 1, '1.23'}], 1}
      assert :json5_lexer.string('+1.23') == {:ok, [{:number, 1, '+1.23'}], 1}
      assert :json5_lexer.string('-1.23') == {:ok, [{:number, 1, '-1.23'}], 1}
    end

    test "onlyFractionPart" do
      assert :json5_lexer.string('.23') == {:ok, [{:number, 1, '.23'}], 1}
      assert :json5_lexer.string('+.23') == {:ok, [{:number, 1, '+.23'}], 1}
      assert :json5_lexer.string('-.23') == {:ok, [{:number, 1, '-.23'}], 1}
    end

    test "onlyTrailingFractionPart" do
      assert :json5_lexer.string('23.') == {:ok, [{:number, 1, '23.'}], 1}
      assert :json5_lexer.string('+23.') == {:ok, [{:number, 1, '+23.'}], 1}
      assert :json5_lexer.string('-23.') == {:ok, [{:number, 1, '-23.'}], 1}
    end

    test "withExponent" do
      assert :json5_lexer.string('123e456') == {:ok, [{:number, 1, '123e456'}], 1}
      assert :json5_lexer.string('123e-456') == {:ok, [{:number, 1, '123e-456'}], 1}
      assert :json5_lexer.string('123e+456') == {:ok, [{:number, 1, '123e+456'}], 1}
      assert :json5_lexer.string('123E-456') == {:ok, [{:number, 1, '123E-456'}], 1}
      assert :json5_lexer.string('+123e-456') == {:ok, [{:number, 1, '+123e-456'}], 1}
      assert :json5_lexer.string('-123e-456') == {:ok, [{:number, 1, '-123e-456'}], 1}
    end
  end

  describe "object" do
    test "identifier" do
      assert :json5_lexer.string('{a:1,$:3}') ==
               {:ok,
                [
                  {:"{", 1},
                  {:identifier, 1, 'a'},
                  {:":", 1},
                  {:number, 1, '1'},
                  {:",", 1},
                  {:identifier, 1, '$'},
                  {:":", 1},
                  {:number, 1, '3'},
                  {:"}", 1}
                ], 1}
    end

    test "complex" do
      assert :json5_lexer.string('{"a": 1}') ==
               {:ok, [{:"{", 1}, {:dq_string, 1, '"a"'}, {:":", 1}, {:number, 1, '1'}, {:"}", 1}],
                1}
    end
  end

  test "array" do
    assert :json5_lexer.string('["a", 1, null, false]') ==
             {:ok,
              [
                {:"[", 1},
                {:dq_string, 1, '"a"'},
                {:",", 1},
                {:number, 1, '1'},
                {:",", 1},
                {:null, 1},
                {:",", 1},
                {:boolean, 1, 'false'},
                {:"]", 1}
              ], 1}
  end

  test "single line comment" do
    assert :json5_lexer.string("// some text\nnull" |> to_charlist) ==
             {:ok, [{:comment, 1, '// some text'}, {:null, 2}], 2}
  end

  test "multi line comment" do
    assert :json5_lexer.string("/* some text\nnull*/null" |> to_charlist) ==
             {:ok, [{:comment, 1, '/* some text\nnull*/'}, {:null, 2}], 2}
  end
end
