defmodule Seeker.Executor do
  alias Seeker.Flow
  alias LightBridge.Instance
  alias LightBridge.Workflow

  def get_config(workflow, params) do
    arguments = workflow
    |> Map.get(:params)
    |> Enum.reduce(Map.new, fn(param, acc) ->
      Map.put(acc, param, Map.get(params, param))
    end)

    nodes = workflow
    |> Map.get(:nodes)
    |> Enum.map(fn(node) ->
      %{ code: code, inports: inports, outports: outports } = node
      |> Map.get("component")
      |> Flow.get_component!

      component = %{ "inports" => inports, "outports" => outports, "code" => code }
      Map.put(node, "component", component)
    end)

    edges = workflow
    |> Map.get(:edges)

    graph = Workflow.do_convert(%{ "nodes" => nodes, "edges" => edges })


    { :ok, pid } = Instance.start_link(graph)
    Instance.register_callback(pid)

    Enum.each(arguments, fn({ param, value }) ->
      Instance.send_message(pid, { String.to_atom(param), value })
    end)

    response = receive do
      { :reply, message } -> message
    end

    { :ok, response }
  end
end
