# part 1
#f = File.read!("input/day12.txt") |> String.strip
#List.flatten(Regex.scan(~r/\-{0,1}\d+/,f)) |> Enum.map(&String.to_integer/1) |> Enum.sum

defmodule AdventOfCode.Day12 do
  def process(path) do
    File.read!(path)
    |> String.strip
    |> transform
  end

  def transform(string) do
    string
    |> String.replace(":", "=>")
    |> String.replace("{", "%{")
    |> Code.eval_string
    |> elem(0)
  end

  def sum(data), do: sum(data, 0)
  def sum(data, acc) when is_integer(data), do: acc + data
  def sum(data, acc) when is_list(data) do
    Enum.reduce(data, acc, fn(x,acc) ->
      acc + sum(x)
    end)
  end
  def sum(data, acc) when is_map(data) do
    cond do
      has_red?(data) -> acc
      true -> Enum.reduce(data, acc, fn({k,v},acc) -> acc + sum(v) end)
    end
  end
  def sum(_, acc), do: acc

  def has_red?(data) do
    Enum.find(data, fn({_,v}) -> v == "red" end) != nil
  end
end

x = AdventOfCode.Day12.process("input/day12.txt")
#x = AdventOfCode.Day12.transform(~s({"d":"red","e":[1,2,3,4],"f":5}))

IO.puts AdventOfCode.Day12.sum(x)
