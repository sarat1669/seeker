defmodule DSLTest do
  use ExUnit.Case
  alias Composer.DSL
  doctest Composer.DSL

  test "should parse null" do
    assert DSL.do_convert(%{ "type" => "null" }) == nil
  end

  test "should parse atoms " do
    assert DSL.do_convert(%{ "type" => "atom", "arguments" => [ "a" ] }) == :a
  end

  test "should parse strings " do
    assert DSL.do_convert(%{ "type" => "string", "arguments" => [ "a" ] }) == "a"
  end

  test "should parse variables" do
    assert DSL.do_convert(%{
      "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }]
    }) == { :var, :a }
  end

  test "should parse !" do
    assert DSL.do_convert(%{ "type" => "!", "arguments" => [ true ] }) == { :!, [ true ] }
  end

  test "should parse +" do
    assert DSL.do_convert(%{ "type" => "+", "arguments" => [ 1 ] }) == { :+, [ 1 ] }
  end

  test "should parse -" do
    assert DSL.do_convert(%{ "type" => "-", "arguments" => [ 1 ] }) == { :-, [ 1 ] }
  end

  test "should parse abs" do
    assert DSL.do_convert(%{ "type" => "abs", "arguments" => [ 1 ] }) == { :abs, [ 1 ] }
  end

  test "should parse =" do
    assert DSL.do_convert(%{
      "type" => "=",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        10
      ]
    }) == { :=, [{ :var, :a }, 10] }
  end

  test "should parse !=" do
    assert DSL.do_convert(%{
      "type" => "!=",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :!=, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse !==" do
    assert DSL.do_convert(%{
      "type" => "!==",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :!==, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse &&" do
    assert DSL.do_convert(%{
      "type" => "&&", "arguments" => [ true, false ]
    }) == { :&&, [ true, false ] }
  end

  test "should parse ||" do
    assert DSL.do_convert(%{
      "type" => "||", "arguments" => [ true, false ]
    }) == { :||, [ true, false ] }
  end

  test "should parse *" do
    assert DSL.do_convert(%{
      "type" => "*",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :*, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse ++" do
    assert DSL.do_convert(%{
      "type" => "++",
      "arguments" => [
        %{ "type" => "list", "arguments" => [ 1, 2, 3 ] },
        %{ "type" => "list", "arguments" => [ 4, 5 ] },
      ]
    }) == { :++, [{ :list, [ 1, 2, 3 ] }, { :list, [ 4, 5 ] }] }
  end

  test "should parse +/2" do
    assert DSL.do_convert(%{
      "type" => "+",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :+, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse --" do
    assert DSL.do_convert(%{
      "type" => "--",
      "arguments" => [
        %{ "type" => "list", "arguments" => [ 1, 2, 3 ] },
        %{ "type" => "list", "arguments" => [ 1, 4, 5 ] },
      ]
    }) == { :--, [{ :list, [ 1, 2, 3 ] }, { :list, [ 1, 4, 5 ] }] }
  end

  test "should parse -/2" do
    assert DSL.do_convert(%{
      "type" => "-",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :-, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse /" do
    assert DSL.do_convert(%{
      "type" => "/",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :/, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse <" do
    assert DSL.do_convert(%{
      "type" => "<",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :<, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse <=" do
    assert DSL.do_convert(%{
      "type" => "<=",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :<=, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse <>" do
    assert DSL.do_convert(%{
      "type" => "<>",
      "arguments" => [
        %{ "type" => "string", "arguments" => [ "factor" ] },
        %{ "type" => "string", "arguments" => [ "18" ] },
      ]
    }) == { :<>, [ "factor", "18" ] }
  end

  test "should parse ==" do
    assert DSL.do_convert(%{
      "type" => "==",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :==, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse ===" do
    assert DSL.do_convert(%{
      "type" => "===",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :===, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse rem" do
    assert DSL.do_convert(%{
      "type" => "rem",
      "arguments" => [
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
        %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
      ]
    }) == { :rem, [{ :var, :a }, { :var, :b }] }
  end

  test "should parse if/2" do
    assert DSL.do_convert(%{
      "type" => "if",
      "arguments" => [
        %{
          "type" => "<",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
          ]
        },
        %{
          "type" => "=",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "c" ] }] },
            10,
          ]
        }
      ]
    }) == { :if, [{ :<, [{ :var, :a }, { :var, :b }] }, { :=, [{ :var, :c }, 10 ] }, nil ] }
  end

  test "should parse if/3" do
    assert DSL.do_convert(%{
      "type" => "if",
      "arguments" => [
        %{
          "type" => "<",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
          ]
        },
        %{
          "type" => "=",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "c" ] }] },
            10,
          ]
        },
        %{
          "type" => "=",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "c" ] }] },
            100,
          ]
        },
      ]
    }) == { :if, [
      { :<, [{ :var, :a }, { :var, :b }] },
      { :=, [{ :var, :c }, 10 ] },
      { :=, [{ :var, :c }, 100 ] }
    ] }
  end

  test "should parse list" do
    assert DSL.do_convert(%{
      "type" => "list",
      "arguments" => [
        1, true, false,
        %{ "type" => "atom", "arguments" => [ "a" ] },
        %{ "type" => "string", "arguments" => [ "a" ] },
        %{ "type" => "var", "arguments" => [ %{ "type" => "atom", "arguments" => [ "a" ] } ] },
      ]
    }) == { :list, [ 1, true, false, :a, "a", { :var, :a } ] }
  end

  test "should parse sum" do
    assert DSL.do_convert(%{ "type" => "sum", "arguments" => [ 1, 2, 3 ] }) == { :sum, [ 1, 2, 3 ] }
  end

  test "should parse block" do
    assert DSL.do_convert(%{
      "type" => "block",
      "arguments" => [
        %{
          "type" => "=",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "a" ] }] },
            10,
          ]
        },
        %{
          "type" => "=",
          "arguments" => [
            %{ "type" => "var", "arguments" => [%{ "type" => "atom", "arguments" => [ "b" ] }] },
            100,
          ]
        }
      ]
    }) == { :block, [{ :=, [{ :var, :a }, 10] }, { :=, [{ :var, :b }, 100] }] }
  end

  test "should parse true" do
    assert DSL.do_convert(true) == true
  end

  test "should parse false" do
    assert DSL.do_convert(false) == false
  end

  test "should parse numbers" do
    assert DSL.do_convert(1) === 1
    assert DSL.do_convert(1.0) === 1.0
  end

  test "should parse binary" do
    assert DSL.do_convert("a") === "a"
  end
end
