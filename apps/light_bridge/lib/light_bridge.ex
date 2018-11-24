defmodule LightBridge do
  alias Composer.DSL
  alias Composer.AST

  def run(json_path) do
    {:ok, json } = File.read(json_path)
    ast = DSL.convert(json)
    elixir_ast = AST.convert(ast)

    { :ok, pid } = Task.start_link(LightBridge.Component, :loop, [
       %{},
       %{ ports: [ :a, :b ] },
       %{
         ports: [ :c ],
         links: [
           %{ from_port: :c, to_port: :output, to_pid: self() }
         ]
       },
       elixir_ast,
       self()
    ])

    send(pid, { :a, 1 })
    send(pid, { :b, 1 })
  end
end
