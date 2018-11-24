defmodule LightBridge.Workflow do
  alias Composer.DSL
  alias Composer.AST

  def convert(json) do
    json
    |> Poison.decode!
    |> do_convert
  end

  def do_convert(%{ "nodes" => nodes, "edges" => edges }) do
    Graph.new(type: :directed)
    |> add_nodes(nodes)
    |> add_edges(edges)
  end

  def add_nodes(graph, nodes) do
    Enum.reduce(nodes, graph, fn(%{ "id" => id, "component" => component, "type" => type }, graph) ->
      %{ "inports" => inports, "outports" => outports, "code" => code } = component
      Graph.add_vertex(graph, id, label: %{
        code: compile_code(code),
        type: String.to_atom(type),
        inports: Enum.map(inports, &String.to_atom/1),
        outports: Enum.map(outports, &String.to_atom/1),
      })
    end)
  end

  def add_edges(graph, edges) do
    Enum.reduce(edges, graph, fn(edge, graph) ->
      %{
        "source_node" => source_node,
        "source_port" => source_port,
        "target_node" => target_node,
        "target_port" => target_port,
      } = edge

      Graph.add_edge(graph, source_node, target_node, label: %{
        from_port: String.to_atom(source_port), to_port: String.to_atom(target_port),
      })
    end)
  end

  defp compile_code(code) do
    code
    |> DSL.do_convert
    |> AST.convert
  end
end
