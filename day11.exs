defmodule AdventOfCode.Day11 do
  def process(input) when is_binary(input) do
    input
    |> String.to_char_list
    |> Enum.reverse
    |> inc
    |> process
  end

  def process(input) do
    #IO.puts "Working on #{Enum.reverse(input)}"
    cond do
      valid?(Enum.reverse(input)) -> input |> Enum.reverse
      true -> process(inc(input))
    end
  end

  def valid?(input) when is_binary(input) do
    cl = String.to_char_list(input)
    valid?(cl)
  end

  def valid?(input) do
    increasing?(input) &&
    !blacklisted?(input) &&
    doubles(input) >= 2
  end

  def inc(input) when is_binary(input) do
    input
    |> String.to_char_list
    |> Enum.reverse
    |> inc
    |> Enum.reverse
  end

  def inc([char|rest]) when char == ?z, do: [?a|inc(rest)]
  def inc([char|rest]), do: [char+1|rest]
  def inc([]), do: []

  def increasing?([a,b,c|rest])  do
    cond do
     (b == (a+1) && c == (b+1)) -> true
     true -> increasing?([b,c|rest])
    end
  end
  def increasing?(_), do: false

  def blacklisted?([]), do: false
  def blacklisted?([a|rest]) when a in 'iol', do: true
  def blacklisted?([_|rest]), do: blacklisted?(rest)

  def doubles(char_list), do: doubles(char_list, 0)
  def doubles([a,b|rest], found) when a==b do
    doubles(rest, found + 1)
  end
  def doubles([a,b|rest], found), do: doubles([b|rest], found)
  def doubles(_, found), do: found
end


IO.puts AdventOfCode.Day11.process("vzbxkghb")
IO.puts AdventOfCode.Day11.process("vzbxxyzz")
#IO.puts AdventOfCode.Day11.process("abcdefgh")
#IO.puts AdventOfCode.Day11.process("ghijklmn")

#IO.puts AdventOfCode.Day11.valid?("abcdffaa")
#IO.puts AdventOfCode.Day11.valid?("ghjaabcc")
#IO.puts AdventOfCode.Day11.valid?("abci")
#IO.puts AdventOfCode.Day11.valid?("abcdffaa")

#AdventOfCode.Day11.doubles("abcdffaa")
