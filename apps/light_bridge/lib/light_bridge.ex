defmodule LightBridge do
  @moduledoc """
  LightBridge is a FBP-ish workflow executor which supports Composer.DSL

  LightBridge is a network of components, which pass messages

  A component is a process which listens for messages on its in-ports and once the messages arrive,
  executes its application logic and sends messages on its out-ports

  Even though a component deals with only one thing, multiple components can be combined together
  using Workflow to execute them in an order.

  The order and connections between components is defined by acyclic graphs.
  """
  alias LightBridge.Instance
  alias LightBridge.Workflow

  @doc """
  Executes the workflow defined in the file at `json_path` with the given arguments and returns the
  output

  ## Example
     iex> LightBridge.run("test/support/sample_workflow.json", [ a: 1, b: 2 ])
     {:reply, %{ c: 6}}
  """
  def run(json_path, arguments) do
    {:ok, json } = File.read(json_path)

    graph = Workflow.convert(json)

    { :ok, pid } = Instance.start_link(graph)

    Instance.register_callback(pid)

    Enum.each(arguments, fn({ param, value }) ->
      Instance.send_message(pid, { param, value })
    end)

    receive do
      message -> message
    end
  end
end
