defmodule A do
  def process(s) do
    process(String.to_char_list(s), 0, 0)
  end
  def process(_, position, net) when net < 0, do: position
  def process([], position, _), do: position

  def process([char|rest], position, net) do
    position = position + 1
    case char do
      41 -> process(rest, position, net - 1)
      40 -> process(rest, position, net + 1)
    end
  end
end

file = File.read!("day1.txt") |> String.strip
IO.inspect A.process(")") == 1
IO.inspect A.process("()())") == 5
IO.inspect A.process(file)
