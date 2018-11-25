defmodule LightBridgeTest do
  use ExUnit.Case
  doctest LightBridge

  test "integrity" do
    assert LightBridge.run("test/support/sample_workflow.json", [a: 1, b: 2]) == {:reply, %{ c: 6}}
  end
end
