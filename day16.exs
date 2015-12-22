defmodule AdventOfCode.Day16 do
  def process(path) do
    File.read!(path)
      |> String.strip
      |> String.split("\n")
      |> Enum.map(&parse/1)
  end

  def parse(line) do
    Regex.run(~r/Sue (\d+): (.*)/, line)
    |> Enum.at(2)
    |> String.split(", ")
    |> Enum.reduce(%{ }, fn(x, acc) ->
      [name, count] = String.split(x, ": ")
      Dict.put(acc, String.to_atom(name), String.to_integer(count))
    end)
  end

  def filter(key, value, struct) do
    IO.inspect(struct)
    IO.puts "#{key}==#{value}"
    Enum.filter(struct, fn(x) ->
      IO.inspect(x)
      cond do
        !Dict.has_key?(x, key) ->
          true
        Dict.has_key?(x, key) ->
          #Dict.fetch!(x, key) == value # part 1
          valid?(key, Dict.fetch!(x, key), value) # part 2
        true ->
          false
      end
    end)
  end

  defp valid?(key,value,compare) do
    case key do
      :cats -> value > compare
      :trees -> value > compare
      :pomeranians -> value < compare
      :goldfish -> value < compare
      _ -> value == compare # part 1
    end
  end
end

o = AdventOfCode.Day16.process("input/day16.full")

#o = AdventOfCode.Day16.parse("Sue 1: goldfish: 9, cars: 0, samoyeds: 9")

IO.inspect Enum.reduce([children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1], o, fn({k,v},acc) ->
  #IO.inspect acc
  #IO.puts k
  #IO.puts v
  AdventOfCode.Day16.filter(k, v, acc)
end)

#IO.inspect AdventOfCode.Day16.filter(:goldfish, 4, [o])
#IO.inspect AdventOfCode.Day16.filter(:children, 4, [o])
#IO.inspect AdventOfCode.Day16.filter(:goldfish, 9, [o])
