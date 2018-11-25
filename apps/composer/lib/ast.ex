defmodule Composer.AST do
  def convert(ast) do
    do_convert(ast)
  end

  def do_convert({ :block, args }) do
    { :__block__, [], Enum.map(args, &do_convert/1) }
  end

  def do_convert({ :var, var }) do
    {
      :var!,
      [ context: Composer.AST, import: Kernel ],
      [ { var, [], Elixir }]
    }
  end

  def do_convert({ :!, [ var ] }) do
    quote do
      !unquote(do_convert(var))
    end
  end

  def do_convert({ :+, [ var ] }) do
    quote do
      +unquote(do_convert(var))
    end
  end

  def do_convert({ :-, [ var ] }) do
    quote do
      -unquote(do_convert(var))
    end
  end

  def do_convert({ :abs, [ var ]}) do
    quote do
      abs(unquote(do_convert(var)))
    end
  end

  def do_convert({ :=, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) = unquote(do_convert(right))
    end
  end

  def do_convert({ :!=, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) != unquote(do_convert(right))
    end
  end

  def do_convert({ :!==, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) !== unquote(do_convert(right))
    end
  end

  def do_convert({ :&&, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) && unquote(do_convert(right))
    end
  end

  def do_convert({ :||, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) || unquote(do_convert(right))
    end
  end

  def do_convert({ :*, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) * unquote(do_convert(right))
    end
  end

  def do_convert({ :++, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) ++ unquote(do_convert(right))
    end
  end

  def do_convert({ :+, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) + unquote(do_convert(right))
    end
  end

  def do_convert({ :--, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) -- unquote(do_convert(right))
    end
  end

  def do_convert({ :-, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) - unquote(do_convert(right))
    end
  end

  def do_convert({ :/, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) / unquote(do_convert(right))
    end
  end

  def do_convert({ :<, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) < unquote(do_convert(right))
    end
  end

  def do_convert({ :<=, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) <= unquote(do_convert(right))
    end
  end

  def do_convert({ :<>, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) <> unquote(do_convert(right))
    end
  end

  def do_convert({ :==, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) == unquote(do_convert(right))
    end
  end

  def do_convert({ :===, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) === unquote(do_convert(right))
    end
  end

  def do_convert({ :>, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) > unquote(do_convert(right))
    end
  end

  def do_convert({ :>=, [ left, right ] }) do
    quote do
      unquote(do_convert(left)) >= unquote(do_convert(right))
    end
  end

  def do_convert({ :rem, [ left, right ] }) do
    quote do
      rem(unquote(do_convert(left)), unquote(do_convert(right)))
    end
  end

  def do_convert({ :if, [ conditions, first_clause, second_clause ] }) do
    quote do
      if(unquote(do_convert(conditions))) do
        unquote(do_convert(first_clause))
      else
        unquote(do_convert(second_clause))
      end
    end
  end

  def do_convert({ :list, elements }) do
    Enum.map(elements, fn(element) ->
      quote do: unquote do_convert(element)
    end)
  end

  def do_convert({ :sum, arguments }) do
    [ h | t ] = arguments
    value = quote do: unquote do_convert(h)
    Enum.reduce(t, value, fn(n, acc) ->
      a = quote do: unquote do_convert(n)
      { :+, [], [ a, acc]}
    end)
  end

  def do_convert(nil), do: nil

  def do_convert(true), do: true

  def do_convert(false), do: false

  def do_convert(x) when is_atom(x), do: x

  def do_convert(x) when is_binary(x), do: x

  def do_convert(x) when is_number(x), do: x
end
