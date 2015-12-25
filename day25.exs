defmodule AdventOfCode.Day25 do
  @m 252533
  @d 33554393

  def run(grid, get_pt) do
    Stream.iterate(0, &(&1+1)) |>
    Stream.scan(grid, fn(i,{coord,val}) -> {next_coord(coord),rem(val*@m,@d)} end)
    |> Enum.find(fn({coord,val})-> coord == get_pt end)
  end

  def next_coord({col,1}), do: {1,col+1}
  def next_coord({col,row}), do: {col+1,row-1}
end

AdventOfCode.Day25.run({{1,1},20151125}, {3029,2947})
#AdventOfCode.Day25.run({{1,1},20151125}, {6,6})
|> IO.inspect
