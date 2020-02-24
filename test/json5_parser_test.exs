defmodule JSON5ParerTest do
  use ExUnit.Case

  test "array" do
    tokens = [
      {:"[", 1},
      {:dq_string, 1, '"a"'},
      {:",", 1},
      {:number, 1, '1'},
      {:",", 1},
      {:null, 1},
      {:",", 1},
      {:boolean, 1, 'false'},
      {:"]", 1}
    ]

    assert :json5_parser.parse(tokens) == {:ok, ["a", 1, nil, false]}
  end

  test "object" do
    tokens = [
      {:"{", 1},
      {:identifier, 1, 'a'},
      {:":", 1},
      {:number, 1, '1'},
      {:",", 1},
      {:identifier, 1, '$'},
      {:":", 1},
      {:boolean, 1, 'true'},
      {:"}", 1}
    ]

    assert :json5_parser.parse(tokens) == {:ok, %{"a" => 1, "$" => true}}
  end

  test "null" do
    tokens = [{:null, 1}]

    assert :json5_parser.parse(tokens) == {:ok, nil}
  end

  test "number" do
    tokens = [{:number, 1, '345'}]

    assert :json5_parser.parse(tokens) == {:ok, 345}
  end

  test "boolean" do
    true_tokens = [{:boolean, 1, 'true'}]
    false_tokens = [{:boolean, 1, 'false'}]

    assert :json5_parser.parse(true_tokens) == {:ok, true}
    assert :json5_parser.parse(false_tokens) == {:ok, false}
  end

  test "remove comments" do
    single_line_tokens = [{:comment, 1, '// some text'}, {:boolean, 2, 'true'}]
    multi_line_tokens = [{:comment, 1, '/* some text\nnull*/'}, {:boolean, 2, 'false'}]

    assert :json5_parser.parse(single_line_tokens) == {:ok, true}
    assert :json5_parser.parse(multi_line_tokens) == {:ok, false}
  end
end
