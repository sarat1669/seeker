defmodule LightBridge.Component do
  def run(inports, outports_config, code) do
    { _response, binding } = Code.eval_quoted(code, Map.to_list(inports))
    outports = Enum.reduce(binding, %{}, fn({k, v}, acc) -> Map.put(acc, k, v) end)
    outports_config
    |> Map.get(:links)
    |> Enum.each(fn(%{ from_port: from_port, to_port: to_port, to_node: to_node }) ->
      send(to_node, { to_port, Map.get(outports, from_port) })
    end)
  end

  def loop(inports, inports_config, outports_config, code) do
    receive do
      { port, value } when is_atom(port) ->
        inports = Map.put(inports, port, value)
        if(inports_config |> Map.get(:ports) |> Enum.all?(&(Map.has_key?(inports, &1)))) do
          run(inports, outports_config, code)
        else
          loop(inports, inports_config, outports_config, code)
        end
    end
  end
end
