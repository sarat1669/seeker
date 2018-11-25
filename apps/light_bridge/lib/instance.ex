defmodule LightBridge.Instance do
  @moduledoc """
    Instance is implemented using GenServer It takes a graph and initializes the nodes as processes.
    And establishes the connections between the processes.

    Once the workflow execution is complete, it sends a message to the callback_pid with the
    response
  """

  use GenServer

  @doc """
  Starts the GenServer with the graph generated from json using `LightBridge.Workflow`.
  """
  def start_link(graph) do
    GenServer.start_link(__MODULE__, { :ok, graph })
  end

  @doc """
  Sends the message to the component of type :in
  """
  def send_message(server, message) do
    GenServer.call(server, { :send_message, message })
  end

  @doc """
  Register the caller pid as :callback_pid and sends a message once the execution is done
  """
  def register_callback(server) do
    GenServer.call(server, { :register_callback })
  end

  @doc """
  Initializes the nodes as processes and establishes the connections between the processes.
  """
  def init({ :ok, graph }) do
    initial_state = Map.new()
    |> Map.put(:response, %{})
    |> Map.put(:graph, graph)
    |> Map.put(:lookup_table, Map.new())

    state = graph
    |> Graph.topsort
    |> Enum.reverse
    |> Enum.reduce(initial_state, fn(node, state) ->
      lookup_table = Map.get(state, :lookup_table)

      [{ :label, data }] = Graph.vertex_labels(graph, node)
      %{ code: code, inports: inports, outports: outports, type: type } = data

      { :ok, pid } = Task.start_link(LightBridge.Component, :loop, [
         %{},
         %{ ports: inports },
         %{ ports: outports, links: get_links(graph, node, lookup_table, type) },
         code
      ])

      state = if(Enum.member?([ :in, :out ], type)) do
        Map.put(state, type, node)
      else
        state
      end

      state
      |> Map.put(:lookup_table,
        lookup_table
        |> Map.put(node, pid)
      )
    end)

    { :ok, state }
  end

  def handle_call({ :send_message, message }, _from, state) do
    node = Map.get(state, :in)
    pid = state
    |> Map.get(:lookup_table)
    |> Map.get(node)

    send(pid, message)
    { :reply, :ok, state }
  end

  def handle_call({ :register_callback }, { pid, _ref }, state) do
    { :reply, :ok, Map.put(state, :callback_pid, pid) }
  end


  def handle_info({ port, value}, state) do
    response = Map.get(state, :response)
    |> Map.put(port, value)

    node = Map.get(state, :out)
    graph = Map.get(state, :graph)

    [{ :label, data }] = Graph.vertex_labels(graph, node)
    %{ outports: outports } = data

    if(outports |> Enum.all?(&(Map.has_key?(response, &1)))) do
      if(Map.has_key?(state, :callback_pid)) do
        send(Map.get(state, :callback_pid), { :reply, response })
      end
      { :stop, :normal, state }
    else
      { :noreply, Map.put(state, :response, response) }
    end
  end

  defp get_links(graph, node, lookup_table, type) do
    out_edges = Graph.out_edges(graph, node)

    links = Enum.map(out_edges, fn(edge) ->
      %{ v2: to_node, label: link_data } = edge
      Map.put(link_data, :to_node, Map.get(lookup_table, to_node))
    end)

    if(type != :out) do
      links
    else
      [{ :label, data }] = Graph.vertex_labels(graph, node)
      %{ outports: outports } = data
      links ++ Enum.map(outports, fn(outport) ->
        %{ from_port: outport, to_port: outport, to_node: self() }
      end)
    end
  end
end
