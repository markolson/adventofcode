defmodule AdventOfCode.Day18 do
  def process(file) do
    File.read!(file)
    |> String.strip
  end
end

AdventOfCode.Day18.process("input/day18.sample")
