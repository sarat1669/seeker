defmodule LightBridge do
  alias LightBridge.Instance
  alias LightBridge.Workflow

  def run(json_path) do
    {:ok, json } = File.read(json_path)

    graph = Workflow.convert(json)

    { :ok, pid } = Instance.start_link(graph)

    :ok = Instance.register_callback(pid)
    :ok = Instance.send_message(pid, { :a, 1 })
    :ok = Instance.send_message(pid, { :b, 2 })

    receive do
      message -> message
    end
  end
end
