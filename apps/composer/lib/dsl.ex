defmodule Composer.DSL do
  @moduledoc """
  Provies methods to generate custom AST from JSON DSL.

  The DSL is made of expressions and each expression has a type, arguments

  Example: `{ "type": "string", "arguments": [ "factor18" ]}`

  Currently the following expressions are allowed:

  type `null` accepts no arguments
  `{ "type": "null" }`

  type `atom` accepts a single string as an argument
  `{ "type": "atom", "arguments" => [ "a" ] }`

  type `string` accepts a single string as an argument
  `{ "type": "string", "arguments" => [ "a" ] }`

  type `var` accepts an atom expression as an argument
  `{ "type": "var", "arguments" => [{ "type": "atom", "arguments" => [ "a" ] }] }`

  type `!` accepts an expression as an argument

  type `+` accepts an expression as an argument

  type `-` accepts an expression as an argument

  type `abs` accepts an expression as an argument

  type `=` accepts two expressions as arguments

  type `!=` accepts two expressions as arguments

  type `!==` accepts two expressions as arguments

  type `&&` accepts two expressions as arguments

  type `||` accepts two expressions as arguments

  type `*` accepts two expressions as arguments

  type `++` accepts two expressions as arguments

  type `+` accepts two expressions as arguments

  type `--` accepts two expressions as arguments

  type `-` accepts two expressions as arguments

  type `/` accepts two expressions as arguments

  type `<` accepts two expressions as arguments

  type `<=` accepts two expressions as arguments

  type `<>` accepts two expressions as arguments

  type `==` accepts two expressions as arguments

  type `===` accepts two expressions as arguments

  type `>` accepts two expressions as arguments

  type `>=` accepts two expressions as arguments

  type `rem` accepts two expressions as arguments

  type `if` accepts two/three expressions as arguments

  The first argument is the conditions, second expression is executed if the conditions evaluate
  to true and the third argument is evaluated when the conditions evaluate to false

  type `list` accepts a finite number of expressions as arguments

  type `sum` accepts a finite number of expressions as arguments

  type `block` accepts a finite number of expressions as arguments

  ## Example DSL

  ```elixir
  {
    "type": "block", "arguments": [
      {
        "type": "=", "arguments": [
          { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "acc" ] }] },
          {
            "type": "sum", "arguments": [
              { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "a" ] }] },
              { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "b" ] }] },
              { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "c" ] }] }
            ]
          }
        ]
      },
      {
        "type": "block", "arguments": [
          {
            "type": "=", "arguments": [
              { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "a" ] }] },
              100
            ]
          },
          {
            "type": "sum", "arguments": [
              { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "acc" ] }] },
              { "type": "var", "arguments": [{ "type": "atom", "arguments": [ "a" ] }] }
            ]
          }
        ]
      }
    ]
  }
  ```
  """

  @doc """
  Parses the DSL given in a json file and generates custom AST which can be consumed by
  Composer.AST to generate elixir AST

  ## Example
     iex> json = File.read!("test/support/var.json")
     iex> Composer.DSL.convert(json)
     {:var, :a}
  """
  def convert(json) do
    json
    |> Poison.decode!
    |> do_convert
  end

  @doc """
  Converts the DST to custom AST

  ## Example
     iex> Composer.DSL.do_convert(%{ "type" => "+", "arguments" => [ 10, 20 ]})
     { :+, [10, 20] }
  """
  def do_convert(%{ "type" => "null" }) do
    nil
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
    do_convert(%{ "type" => "if", "arguments" => [ conditions, first_clause, %{ "type" => "null" } ] })
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

  def do_convert(%{ "type" => "block", "arguments" => arguments }) do
    { :block, Enum.map(arguments, &do_convert/1) }
  end

  def do_convert(true), do: true

  def do_convert(false), do: false

  def do_convert(x) when is_binary(x), do: x

  def do_convert(x) when is_number(x), do: x
end
