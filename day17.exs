defmodule AdventOfCode.Day17 do
  def process(fill, file) do
    buckets =  File.read!(file) |> String.strip |> String.split("\n") |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..length(buckets), [], fn(x,acc) ->
      acc ++ combinations(buckets, x)
    end)
    #|> part_one(fill)
    |> part_two(fill)
  end

  def part_one(list, fill) do
    list
    |> Enum.map(&Enum.sum/1)
    |> Enum.filter(&(&1 === fill))
    |> length
    |> IO.inspect
  end

  def part_two(list, fill) do
    solutions = list |> Enum.filter(&(Enum.sum(&1) === fill))
    shortest = Enum.sort(solutions, fn(a,b) -> length(a) < length(b) end) |> hd |> length
    solutions |> Enum.filter(&(length(&1) === shortest)) |> length |> IO.inspect
  end

  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []
  def combinations([x|xs], n) do
    (for y <- combinations(xs, n - 1), do: [x|y]) ++ combinations(xs, n)
  end
end



AdventOfCode.Day17.process(25, "input/day17.sample")
AdventOfCode.Day17.process(150, "input/day17.full")
#IO.inspect AdventOfCode.Day17.combinations([20,15,10,5,5], 5)
