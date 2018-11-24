defmodule Composer do
  alias Composer.DSL
  alias Composer.AST

  def parse(json_path, arguments) do
    {:ok, json } = File.read(json_path)
    ast = DSL.convert(json)
    elixir_ast = AST.convert(ast)
    Code.eval_quoted(elixir_ast, arguments)
  end
end
