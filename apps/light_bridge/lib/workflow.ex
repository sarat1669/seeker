defmodule LightBridge.Workflow do
  @moduledoc """
  Converts the workflow defined in the json into a Graph which can be used by LightBridge.Instance

  A workflow is defined using an acyclic graph. The nodes of the graph are the components and the
  links between them define the connections.

  #### Node
  A node has an `id`, `type`, `component`

  `id ` should be unique for each node

  A node can be of three types: "in", "normal", "out"

  #### Component
  A component consists of `inports`, `outports`, `code`

  `inports` is a list of atoms, which will be provided as the binding to the worflow for execution

  `outports` is a list of atoms from the binding which will be used to construct the response object

  `code` is the DSL which is defined in `Composer.DSL`

  #### Edges
  An edge has a `sorce_node`, `source_port`, `target_node`, `target_port`

  `source_node` is the ID of the node from which the connection is originating

  `source_port` is the port of the node from which the connection is originating

  `target_node` is the ID of the node to which the connection is going

  `target_port` is the port of the node to which the connection is going

  ### Sample Workflow JSON

  ```elixir
  {
    "nodes": [
      {
        "id": 0, "type": "in", "component": {
          "inports": [ "a", "b" ],
          "outports": [ "c" ],
          "code": {
            "type": "=", "arguments": [
              { "type": "var", "arguments": [ { "type": "atom", "arguments": [ "c" ] } ] },
              {
                "type": "+", "arguments": [
                  { "type": "var", "arguments": [ { "type": "atom", "arguments": [ "a" ] } ] },
                  { "type": "var", "arguments": [ { "type": "atom", "arguments": [ "b" ] } ] }
                ]
              }
            ]
          }
        }
      },
      {
        "id": 1, "type": "out", "component": {
          "inports": [ "a", "b" ],
          "outports": [ "c" ],
          "code": {
            "type": "=", "arguments": [
              { "type": "var", "arguments": [ { "type": "atom", "arguments": [ "c" ] } ] },
              {
                "type": "+", "arguments": [
                  { "type": "var", "arguments": [ { "type": "atom", "arguments": [ "a" ] } ] },
                  { "type": "var", "arguments": [ { "type": "atom", "arguments": [ "b" ] } ] }
                ]
              }
            ]
          }
        }
      }
    ],
    "edges": [
      { "source_node": 0, "target_node": 1, "source_port": "c", "target_port": "a" },
      { "source_node": 0, "target_node": 1, "source_port": "c", "target_port": "b" }
    ]
  }
  ```
  """
  alias Composer.DSL
  alias Composer.AST

  @doc """
  Parses the json and generates the json
  """
  def convert(json) do
    json
    |> Poison.decode!
    |> do_convert
  end

  @doc """
  Generates the graph from the nodes and edges.

  It expects the input as `%{ "nodes" => nodes, "edges" => edges }`
  """
  def do_convert(%{ "nodes" => nodes, "edges" => edges }) do
    Graph.new(type: :directed)
    |> add_nodes(nodes)
    |> add_edges(edges)
  end

  defp add_nodes(graph, nodes) do
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

  defp add_edges(graph, edges) do
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
    |> AST.do_convert
  end
end
