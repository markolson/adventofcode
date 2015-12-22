defmodule A do
  require Bitwise
  @r_or ~r/(.*) OR (.*)/
  @r_and ~r/(.*) AND (.*)/
  @r_lshift ~r/(.*) LSHIFT (.*)/
  @r_rshift ~r/(.*) RSHIFT (.*)/
  @r_twoop ~r/(?<a>.*) .* (?<b>.*)/
  @r_not ~r/NOT .*/

  def structurize(input) when is_binary(input) do
    String.split(input, "\n") |> structurize
  end

  def structurize(list), do: structurize(list, %{})
  def structurize([head|rest], structure) do
    %{"in" => input, "out" => out} = Regex.named_captures(~r/(?<in>.*) -> (?<out>.*)/, head)
    structurize(rest, Dict.put(structure, out, t(input)))
  end
  def structurize([], structure), do: structure

  def calculate(input,structure) when is_integer(input), do: %{result: input, structure: structure}
  def calculate(input,structure) do
    {:ok, expression} = Dict.fetch(structure, input)
    result = cond do
      is_integer(expression) ->
        expression
      Regex.match?(@r_not, expression) ->
        %{"a" => a_key} = Regex.named_captures(~r/NOT (?<a>.*)/, expression)
        %{result: a, structure: structure} = calculate(t(a_key), structure)
        Bitwise.band(Bitwise.bnot(a),0xFFFF)
      Regex.match?(@r_or, expression) ->
        %{"a" => a_key, "b" => b_key} = Regex.named_captures(@r_twoop, expression)
        %{result: a, structure: structure} = calculate(a_key, structure)
        %{result: b, structure: structure} = calculate(b_key, structure)
        Bitwise.bor(a, b)
      Regex.match?(@r_and, expression) ->
        %{"a" => a_key, "b" => b_key} = Regex.named_captures(@r_twoop, expression)
        %{result: a, structure: structure} = calculate(t(a_key), structure)
        %{result: b, structure: structure} = calculate(t(b_key), structure)
        Bitwise.band(a, b)
      Regex.match?(@r_lshift, expression) ->
        %{"a" => a_key, "b" => b_key} = Regex.named_captures(@r_twoop, expression)
        %{result: a, structure: structure} = calculate(t(a_key), structure)
        b = String.to_integer(b_key)
        Bitwise.bsl(a, b)
      Regex.match?(@r_rshift, expression) ->
        %{"a" => a_key, "b" => b_key} = Regex.named_captures(@r_twoop, expression)
        %{result: a, structure: structure} = calculate(t(a_key), structure)
        b = String.to_integer(b_key)
        Bitwise.bsr(a, b)
      true ->
        IO.puts expression
        %{result: a, structure: structure} = calculate(expression, structure)
        a
    end
    %{result: result, structure: Dict.put(structure, input, result)}
  end

  defp t(lhs) do
    if Regex.match?(~r/^\d*$/, lhs), do: String.to_integer(lhs), else: lhs
  end
end


input = "123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i"

#res = A.structurize(input)

i = A.structurize(String.strip(File.read!("day7.txt")))

#test = %{"n" => "NOT x", "x" => 8, "y" => 3, "z" => 2, "aa" => "z AND y", "a" => "x OR aa"}
#IO.inspect A.calculate("a", test)[:result] == 10
#IO.inspect A.calculate("aa", test)[:result] == 2
#IO.inspect A.calculate("n", test)[:result] == -9
result = A.calculate("a", i)
IO.inspect result
