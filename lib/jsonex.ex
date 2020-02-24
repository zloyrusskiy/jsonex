defmodule Jsonex do
  @moduledoc """
  Documentation for `Jsonex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Jsonex.parse("{a:1,$:false}")
      %{"a" => 1, "$" => false}

  """
  def parse(str) do
    charlist = str |> to_charlist

    with {:ok, tokens, _} <- :json5_lexer.string(charlist),
         {:ok, result} <- :json5_parser.parse(tokens) do
      result
    end
  end
end
