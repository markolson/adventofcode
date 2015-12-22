defmodule AdventOfCode.Day15 do
  def process(path, count) do
    t = File.read!(path)
      |> String.strip
      |> String.split("\n")
      |> Enum.map(&parse/1)

    combos = _combinations(count) |> List.flatten |> Enum.chunk 4
    Enum.map(combos, fn x -> score(t,x) end) |> Enum.sort |> Enum.reverse
  end

  def parse(line) do
    [_,_,rest] = Regex.run(~r/(\w+): (.*)/, line)
    String.split(rest, ", ")
    |> Enum.map(&String.split/1)
    |> Enum.reduce(%{}, fn([k,v],acc) ->
      Dict.put(acc, k, String.to_integer(v))
    end) |> Dict.values
  end

  def score(struct, combo) do
    [calories|rest] = List.zip([combo, struct])
    |> Enum.map(fn({m,items} ) -> Enum.map(items, &(&1 * m)) end)
    |> List.zip
    |> Enum.map(fn x -> Enum.sum(Tuple.to_list(x)) end )
    cond do
      Enum.min(rest) < 0 -> 0
      calories !== 500 -> 0 # comment out for part 1
      true -> Enum.reduce(rest, 1, fn(x,acc) -> x * acc end)
    end
  end

  def _combinations(n) do
    for i <- 0..n do
      for j <- 0..(n - i) do
        for k <- 0..(n - i - j) do
          for l <- 0..(n - i - j - k), (i + j + k + l) == n do
              [i, j, k, l]
          end
        end
      end
    end
  end
end


a = AdventOfCode.Day15.process("input/day15.sample", 100)
#IO.puts Enum.max(a) == 62842880 # part 1
IO.puts Enum.max(a) == 57600000 # part 2
b = AdventOfCode.Day15.process("input/day15.full", 100)
IO.inspect b
#IO.puts Enum.max(b) == 21367368

#o = AdventOfCode.Day15.process("input/day15.sample", 2)
#AdventOfCode.Day15.score(o, [44,56])
#IO.puts AdventOfCode.Day15.score(o, [44,56]) == 62842880


#IO.puts AdventOfCode.Day15.score(o, [40,60]) == 57600000
#IO.puts AdventOfCode.Day15.score(o, [44,56]) == 62842880
