defmodule Composer do
  @moduledoc """
  Composer has two modules Composer.DSL, Composer.AST which convert the DSL into native elixir code.
  The DSL is defined inside Composer.DSL
  """
  alias Composer.DSL
  alias Composer.AST

  @doc """
  Parses the DSL given in a json file and executes the code with the binding provided

  ## Example
     iex> Composer.parse("test/support/adder.json", [ a: 1, b: 2, c: 3 ])
     {6, [a: 1, b: 2, c: 3, d: 6]}
  """
  def parse(json_path, arguments) do
    {:ok, json } = File.read(json_path)
    ast = DSL.convert(json)
    elixir_ast = AST.do_convert(ast)
    Code.eval_quoted(elixir_ast, arguments)
  end
end
