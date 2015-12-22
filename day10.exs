defmodule AdventOfCode.Day10 do
  defp parse(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
  def process(path) do
    File.read!(path) |>
      String.strip |>
      String.split("\n") |>
      Enum.map(&parse/1) |>
      Enum.map(&say/1) |>
      Enum.map(&Enum.count/1) |>
      IO.inspect
  end

  def say([number, iterations]) do
    number = String.to_char_list("#{number}")
    say(number, iterations)
  end

  def say(number, 0), do: number
  def say(number, iterations) do
    result = count(number) |> String.to_char_list
    say(result, iterations - 1)
  end

  def count(number) do
    count(number, 0, "")
  end

  def count([], _, acc), do: acc
  def count([char,next|rest], count, acc) when char == next do
    count([next|rest], count + 1, acc)
  end

  def count([char|rest], count, acc) do
    count(rest, 0, acc <> "#{count + 1}#{[char]}")
  end
end

AdventOfCode.Day10.process("input/day10.sample")
AdventOfCode.Day10.process("input/day10.full")
