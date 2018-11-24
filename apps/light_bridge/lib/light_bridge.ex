defmodule LightBridge do
  alias Composer.DSL
  alias Composer.AST
  alias LightBridge.Instance

  def run(json_path) do
    {:ok, json } = File.read(json_path)
    ast = DSL.convert(json)
    elixir_ast = AST.convert(ast)

    graph = Graph.new(type: :directed)
    |> Graph.add_vertex(0, label: %{
      code: elixir_ast, inports: [ :a, :b ], outports: [ :c ], type: :in
    })
    |> Graph.add_vertex(1, label: %{
      code: elixir_ast, inports: [ :a, :b ], outports: [ :c ], type: :out
    })
    |> Graph.add_edge(0, 1, label: %{ from_port: :c, to_port: :a })
    |> Graph.add_edge(0, 1, label: %{ from_port: :c, to_port: :b })

    { :ok, pid } = Instance.start_link(graph)
    Instance.register_callback(pid)
    Instance.send_message(pid, { :a, 1 })
    Instance.send_message(pid, { :b, 2 })

    receive do
      message -> message
    end
  end
end
