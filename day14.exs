defmodule AdventOfCode.Day14.PartOne do
  def process(path, time) do
    File.read!(path)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&transform/1)
    |> Enum.map(&(at(&1,time)))
    |> Enum.sort
    |> Enum.reverse
    |> hd
  end

  def transform(line) do
    Regex.run(~r/.* (\d+) km\/s for (\d+) .* (\d+) seconds./, line, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
  end

  def at(deer, time), do: at(deer, time, 0)
  def at(_, 0, acc), do: acc
  def at(deer=[speed, running, resting], time, acc) do
    actual = rem(time, running + resting) + 1
    cond do
      actual <= running ->
        at(deer, time - 1, acc + speed)
      true ->
        at(deer, time - 1, acc)
    end
  end
end

defmodule AdventOfCode.Day14.PartTwo do
  def process(path, time) do
    File.read!(path)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&transform/1)
    |> work(0)
  end

  def transform(line) do
    [name, speed, run, rest] = Regex.run(~r/(\w+) can .* (\d+) km\/s for (\d+) .* (\d+) seconds./, line, capture: :all_but_first)
    [speed, run, rest] = [speed, run, rest] |> Enum.map(&String.to_integer/1)
    %{"deer": name, speed: speed, run: run, rest: rest, points: 0, position: 0}
  end

  def work(lines, 2503), do: lines
  def work(lines, time) do
    #IO.puts "#### After #{time}"
    lines
    |> Enum.map(&(update_positions(&1,time)))
    |> give_points
    |> work(time + 1)
  end

  def update_positions(struct=%{"position": position, "rest": rest, "run": run, "speed": speed}, time) do
    position = AdventOfCode.Day14.PartOne.at([speed, run, rest], time)
    Dict.put(struct, :position, position)
  end

  def give_points(deer) do
    max = get_furthest(deer)
    Enum.map(deer,
      fn(x) ->
        case Dict.fetch!(x, :position) == max do
        true ->
          #IO.puts "#{x[:deer]} gets a point"
          Dict.get_and_update(x, :points, &({&1, &1 + 1}))
        false -> {true,x}
      end |> elem(1)
    end)
  end

  def get_furthest(deer) do
    Enum.sort(deer, fn(%{position: a},%{position: b}) -> a > b end )
    |> hd
    |> Dict.fetch!(:position)
  end
end

# POS doesn't work because I'm a shitty coder.
IO.puts AdventOfCode.Day14.PartTwo.process("input/day14.full", 2503) == 1084

IO.puts AdventOfCode.Day14.PartOne.process("input/day14.full", 2503) == 2696
