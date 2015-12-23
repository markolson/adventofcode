defmodule AdventOfCode.Day18 do
  def process(file, times) do
    data = File.read!(file)
    |> String.strip
    |> parse

    Enum.reduce(1..times, data, fn(_,acc) ->
      update_for_part_2(acc)
      |> update
      |> format
    end) |> List.flatten |> Enum.filter(&(&1 == ?#))
  end

  def parse(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(&String.to_char_list/1)
  end

  def update_for_part_2(data) do
    c = length(data)-1
    Enum.reduce(0..c, [], fn(x,xacc) ->
      r = Enum.reduce(0..c, '', fn(y,yacc) ->
        t = cond do
          x==0 && y==0 -> '#'
          x==0 && y==c -> '#'
          x==c && y==0 -> '#'
          x==c && y==c -> '#'
          true -> [Enum.fetch!(data, x) |> Enum.fetch!(y)]
        end
        #IO.inspect t ++ yacc
        t ++ yacc
      end) |> Enum.reverse
      [r|xacc]
    end) |> Enum.reverse
  end

  def update(existing) do
    Enum.reduce(0..length(existing)-1, [], fn(x,xacc) ->
      r = Enum.reduce(0..length(existing)-1, '', fn(y,yacc) ->
        pt = get_at(existing, {x,y})
        t = char_for(pt, existing, {x,y})
        t ++ yacc
      end) |> Enum.reverse
      [r|xacc]
    end) |> Enum.reverse
  end

  # for part 2
  def char_for(_,data,{x,y}) when x == 0 and y == 0, do: '#'
  def char_for(_,data,{x,y}) when x == 0 and y == length(data)-1, do: '#'
  def char_for(_,data,{x,y}) when x == length(data)-1 and y == 0, do: '#'
  def char_for(_,data,{x,y}) when x == length(data)-1 and y == length(data)-1, do: '#'

  def char_for(:on, data, coords) do
    case score_for(data, coords) do
      2 -> '#'
      3 -> '#'
      _ -> '.'
    end
  end

  def char_for(:off, data, coords) do
    case score_for(data, coords) do
      3 -> '#'
      _ -> '.'
    end
  end

  def format(data) do
    IO.puts "=OUTPUT="
    IO.puts data |> Enum.join("\n")
    data
  end

  def score_for(data, coords) do
    points_for(coords)
    |> Enum.reduce([], fn(x,acc) ->
      [get_at(data,x)|acc]
    end)
    |> Enum.filter(&(&1 == :on))
    |> length
  end

  def points_for({x,y}) do
    [
      {x-1,y-1},{x,y-1},{x+1,y-1},
      {x-1,y},{x+1,y},
      {x-1,y+1},{x,y+1},{x+1,y+1},
    ]
  end

  def get_at(data, {x,y}) when x >= 0  and y >=0 and length(data) > x and length(data) > y do
    case Enum.fetch!(data, x) |> Enum.fetch!(y) do
      ?# -> :on
      ?. -> :off
    end
  end

  def get_at(_,_), do: false
end

AdventOfCode.Day18.process("input/day18.full", 100)
|> length
|> IO.inspect
#IO.inspect AdventOfCode.Day18.get_at(o,{0,1})
#IO.inspect AdventOfCode.Day18.score_for(o,{0,5})
#IO.inspect AdventOfCode.Day18.update(o) |> AdventOfCode.Day18.format

