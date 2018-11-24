defmodule Composer.DSL do
  def convert(json) do
    json
    |> Poison.decode!
    |> do_convert
  end

  def do_convert(%{ "type" => "block", "arguments" => arguments }) do
    { :block, Enum.map(arguments, &do_convert/1) }
  end

  def do_convert(%{ "type" => "atom", "arguments" => [ word ] }) do
    String.to_atom(word)
  end

  def do_convert(%{ "type" => "string", "arguments" => [ word ] }) do
    word
  end

  def do_convert(%{ "type" => "var", "arguments" => [ var ] }) do
    { :var, do_convert(var) }
  end

  def do_convert(%{ "type" => "!", "arguments" => [ var ] }) do
    { :!, [ do_convert(var) ] }
  end

  def do_convert(%{ "type" => "+", "arguments" => [ var ] }) do
    { :+, [ do_convert(var) ] }
  end

  def do_convert(%{ "type" => "-", "arguments" => [ var ] }) do
    { :-, [ do_convert(var) ] }
  end

  def do_convert(%{ "type" => "abs", "arguments" => [ var ] }) do
    { :abs, [ do_convert(var) ] }
  end

  def do_convert(%{ "type" => "=", "arguments" => [ left, right ] }) do
    { :=, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "!=", "arguments" => [ left, right ] }) do
    { :!=, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "!==", "arguments" => [ left, right ] }) do
    { :!==, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "&&", "arguments" => [ left, right ] }) do
    { :&&, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "||", "arguments" => [ left, right ] }) do
    { :||, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "*", "arguments" => [ left, right ] }) do
    { :*, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "++", "arguments" => [ left, right ] }) do
    { :++, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "+", "arguments" => [ left, right ] }) do
    { :+, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "--", "arguments" => [ left, right ] }) do
    { :--, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "-", "arguments" => [ left, right ] }) do
    { :-, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "/", "arguments" => [ left, right ] }) do
    { :/, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "<", "arguments" => [ left, right ] }) do
    { :<, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "<=", "arguments" => [ left, right ] }) do
    { :<=, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "<>", "arguments" => [ left, right ] }) do
    { :<>, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "==", "arguments" => [ left, right ] }) do
    { :==, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "===", "arguments" => [ left, right ] }) do
    { :===, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => ">", "arguments" => [ left, right ] }) do
    { :>, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => ">=", "arguments" => [ left, right ] }) do
    { :>=, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "rem", "arguments" => [ left, right ] }) do
    { :rem, [ do_convert(left), do_convert(right) ] }
  end

  def do_convert(%{ "type" => "if", "arguments" => [ conditions, first_clause ] }) do
    do_convert(%{ "type" => "if", "arguments" => [ conditions, first_clause, "null" ] })
  end

  def do_convert(%{ "type" => "if", "arguments" => [ conditions, first_clause, second_clause ] }) do
    { :if, [ do_convert(conditions), do_convert(first_clause), do_convert(second_clause) ] }
  end

  def do_convert(%{ "type" => "list", "arguments" => elements }) do
    { :list, Enum.map(elements, &do_convert/1) }
  end

  def do_convert(%{ "type" => "sum", "arguments" => arguments }) do
    { :sum, Enum.map(arguments, &do_convert/1) }
  end

  def do_convert("null"), do: nil

  def do_convert(true), do: true

  def do_convert(false), do: false

  def do_convert(x) when is_binary(x), do: x

  def do_convert(x) when is_number(x), do: x
end
