defmodule ASTTest do
  use ExUnit.Case
  alias Composer.AST
  doctest Composer.AST

  test "should parse variables" do
    assert AST.do_convert({ :var, :a }) == {
      :var!, [ context: Composer.AST, import: Kernel ], [ { :a, [], Elixir }]
    }
  end

  test "should parse !" do
    assert AST.do_convert({ :!, [ true ] }) == {
      :__block__, [], [{:!, [context: Composer.AST, import: Kernel], [true]}]
    }
  end

  test "should parse +" do
    assert AST.do_convert({ :+, [ 1 ] }) == {:+, [context: Composer.AST, import: Kernel], [1]}
  end

  test "should parse -" do
    assert AST.do_convert({ :-, [ 1 ] }) == {:-, [context: Composer.AST, import: Kernel], [1]}
  end

  test "should parse abs" do
    assert AST.do_convert({ :abs, [ 1 ] }) == {:abs, [context: Composer.AST, import: Kernel], [1]}
  end

  test "should parse =" do
    assert AST.do_convert({ :=, [{ :var, :a }, 10] }) == {
      :=, [], [{:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]}, 10]
    }
  end

  test "should parse !=" do
    assert AST.do_convert({ :!=, [{ :var, :a }, { :var, :b }] }) == {
      :!=, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse !==" do
    assert AST.do_convert({ :!==, [{ :var, :a }, { :var, :b }] }) == {
      :!==, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse &&" do
    assert AST.do_convert({ :&&, [ true, false ] }) == {
      :&&, [context: Composer.AST, import: Kernel], [true, false]
    }
  end

  test "should parse ||" do
    assert AST.do_convert({ :||, [ true, false ] }) == {
      :||, [context: Composer.AST, import: Kernel], [true, false]
    }
  end

  test "should parse *" do
    assert AST.do_convert({ :*, [{ :var, :a }, { :var, :b }] }) == {
      :*, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse ++" do
    assert AST.do_convert({ :++, [{ :list, [ 1, 2, 3 ] }, { :list, [ 4, 5 ] }] }) == {
      :++, [context: Composer.AST, import: Kernel], [[1, 2, 3], [4, 5]]
    }
  end

  test "should parse +/2" do
    assert AST.do_convert({ :+, [{ :var, :a }, { :var, :b }] }) == {
      :+, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse --" do
    assert AST.do_convert({ :--, [{ :list, [ 1, 2, 3 ] }, { :list, [ 1, 4, 5 ] }] }) == {
      :--, [context: Composer.AST, import: Kernel], [[1, 2, 3], [1, 4, 5]]
    }
  end

  test "should parse -/2" do
    assert AST.do_convert({ :-, [{ :var, :a }, { :var, :b }] })  == {
      :-, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse /" do
    assert AST.do_convert({ :/, [{ :var, :a }, { :var, :b }] })  == {
      :/, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse <" do
    assert AST.do_convert({ :<, [{ :var, :a }, { :var, :b }] })  == {
      :<, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse <=" do
    assert AST.do_convert({ :<=, [{ :var, :a }, { :var, :b }] })  == {
      :<=, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse <>" do
    assert AST.do_convert({ :<>, [ "factor", "18" ] }) == {
      :<>, [context: Composer.AST, import: Kernel], ["factor", "18"]
    }
  end

  test "should parse ==" do
    assert AST.do_convert({ :==, [{ :var, :a }, { :var, :b }] })  == {
      :==, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse ===" do
    assert AST.do_convert({ :===, [{ :var, :a }, { :var, :b }] })  == {
      :===, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse rem" do
    assert AST.do_convert({ :rem, [{ :var, :a }, { :var, :b }] }) == {
      :rem, [context: Composer.AST, import: Kernel], [
        {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
        {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
      ]
    }
  end

  test "should parse if/2" do
    assert AST.do_convert({
      :if, [{ :<, [{ :var, :a }, { :var, :b }] }, { :=, [{ :var, :c }, 10 ] }, nil]
    }) == {
      :if, [context: Composer.AST, import: Kernel], [
        {
          :<, [context: Composer.AST, import: Kernel],
          [
            {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
            {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
          ]
        },[
          do: {:=, [], [{:var!, [context: Composer.AST, import: Kernel], [{:c, [], Elixir}]}, 10]},
          else: nil
        ]
      ]
    }
  end

  test "should parse if/3" do
    assert AST.do_convert({
      :if, [
        { :<, [{ :var, :a }, { :var, :b }] },
        { :=, [{ :var, :c }, 10 ] },
        { :=, [{ :var, :c }, 100 ] }
      ] }) == {
        :if, [context: Composer.AST, import: Kernel],
        [
          {
            :<, [context: Composer.AST, import: Kernel],
            [
              {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]},
              {:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}
            ]
          },
          [
            do: {:=, [], [{:var!, [context: Composer.AST, import: Kernel], [{:c, [], Elixir}]}, 10]},
            else: {:=, [], [
              {:var!, [context: Composer.AST, import: Kernel], [{:c, [], Elixir}]},
              100
            ]}
         ]
       ]
     }
  end

  test "should parse list" do
    assert AST.do_convert({ :list, [ 1, true, false, :a, "a", { :var, :a } ] }) == [
      1, true, false, :a, "a", {:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]}
    ]
  end

  test "should parse sum" do
    assert AST.do_convert({ :sum, [ 1, 2, 3 ] })  == {:+, [], [3, {:+, [], [2, 1]}]}
  end

  test "should parse block" do
    assert AST.do_convert({
      :block, [{ :=, [{ :var, :a }, 10] }, { :=, [{ :var, :b }, 100] }]
    }) == {:__block__, [], [
      {:=, [], [{:var!, [context: Composer.AST, import: Kernel], [{:a, [], Elixir}]}, 10]},
      {:=, [], [{:var!, [context: Composer.AST, import: Kernel], [{:b, [], Elixir}]}, 100]}
    ]}
  end

  test "should parse nil" do
    assert AST.do_convert(nil) == nil
  end

  test "should parse true" do
    assert AST.do_convert(true) == true
  end

  test "should parse false" do
    assert AST.do_convert(false) == false
  end

  test "should parse atoms" do
    assert AST.do_convert(:a) == :a
  end

  test "should parse numbers" do
    assert AST.do_convert(1) === 1
    assert AST.do_convert(1.0) === 1.0
  end

  test "should parse strings" do
    assert AST.do_convert("factor18") === "factor18"
  end
end
