defmodule ComposerTest do
  use ExUnit.Case
  doctest Composer

  test "integrity" do
    { result, _binding } = Composer.parse("test/support/reassign.json", [ a: 1, b: 2, c: 3])
    assert result == 106
  end
end
