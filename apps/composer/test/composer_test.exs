defmodule ComposerTest do
  use ExUnit.Case
  doctest Composer

  test "greets the world" do
    assert Composer.hello() == :world
  end
end
