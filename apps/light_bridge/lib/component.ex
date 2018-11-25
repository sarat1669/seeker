defmodule LightBridge.Component do
  @moduledoc """
  Component is a simple process which listens to messages received as { port, value }
  And accumulate the messages in `inports`. One all the inports of the given component are
  received, the `run` method is invoked, which executes the DSL passed in the `code` param
  and executes it with the values in the `inports` as the binding and sends the messages to the
  outports from the binding as per the outports_config.
  """

  @doc """
  This method is invoked by the loop when all the inport messages are received
  """
  def run(inports, outports_config, code) do
    { _response, binding } = Code.eval_quoted(code, Map.to_list(inports))
    outports = Enum.reduce(binding, %{}, fn({k, v}, acc) -> Map.put(acc, k, v) end)
    outports_config
    |> Map.get(:links)
    |> Enum.each(fn(%{ from_port: from_port, to_port: to_port, to_node: to_node }) ->
      send(to_node, { to_port, Map.get(outports, from_port) })
    end)
  end

  @doc """
  This method loops and accumulates messages on inports and once all the required inports receive
  messages, it invokes the `run` method
  """
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
