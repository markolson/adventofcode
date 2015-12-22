defmodule A do
  def ribbon(dimensions) do
    wrapping = dimensions |> Enum.sort |> Enum.take(2) |> Enum.map(&(&1*2)) |> Enum.sum
    bow = dimensions |> Enum.reduce(fn(x, acc) -> x * acc end)
    wrapping + bow
  end
end

file = File.read!("day2.txt") |> String.strip |> String.split("\n")
boxes = for line <- file, do: Enum.map(String.split(line, "x"),&String.to_integer/1)

IO.inspect A.ribbon([2,3,4])
IO.inspect A.ribbon([1,1,10])
IO.inspect Enum.map(boxes, &A.ribbon/1) |> Enum.sum
