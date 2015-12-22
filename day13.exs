defmodule AdventOfCode.Day13 do
  def process(path) do
    File.read!(path)
      |> String.strip
      |> String.split("\n")
      |> Enum.reduce(%{}, &build_structure/2)
      |> run
      |> Enum.sort(fn({_,a},{_,b}) -> a > b end)
      |> hd
  end

  def build_structure(line, dict) do
    [_, f, gl, i, n] = Regex.run(~r/(\w+) would (\w+) (\d+) .* (\w+)/, line)
    i = case gl do
      "gain" -> String.to_integer(i)
      "lose" -> 0 - String.to_integer(i)
    end
    new_f = Dict.get(dict, f, %{})
    new_f = Dict.put(new_f, n, i)
    new_f = Dict.put(new_f, "Mark", 0) # Part 2
    Dict.put(dict, f, new_f)
  end

  def run(struct) do
    me = Enum.reduce(Dict.keys(struct), %{}, fn (k,acc) ->
      Dict.put(acc, k, 0)
    end)
    struct = Dict.put(struct, "Mark", me) # part 2
    IO.inspect struct
    permute(Dict.keys(struct))
    |> Enum.map(fn x ->
      chart = [hd(x)|Enum.reverse(x)]
      {chart, calculate(chart, struct)}
    end)
  end

  def calculate([_], _), do: 0
  def calculate([a,b|rest], struct) do
     first = Dict.fetch!(struct, a) |> Dict.get(b)
     second = Dict.fetch!(struct, b) |> Dict.get(a)
     first + second + calculate([b|rest], struct)
  end

  def permute([]), do: [[]]
  def permute(list) do
    for h <- list, t <- permute(list -- [h]), do: [h|t]
  end
end

x = AdventOfCode.Day13.process("input/day13.full")
IO.inspect(x)
#IO.inspect AdventOfCode.Day13.permute(Dict.keys(x))
