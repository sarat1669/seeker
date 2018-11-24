defmodule LightBridgeTest do
  use ExUnit.Case
  doctest LightBridge

  test "greets the world" do
    assert LightBridge.hello() == :world
  end
end
