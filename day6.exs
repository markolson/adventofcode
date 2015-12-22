defmodule A do
  def run_steps([], grid), do: grid
  def run_steps([step|rest], grid) do
    grid = run_step(step, grid)
    run_steps(rest, grid)
  end

  def run_step("", grid), do: grid
  def run_step(instruction, grid) do
    IO.puts instruction
    [_,action|coords] = Regex.run(~r/(\w+) (\d+),(\d+) through (\d+),(\d+)/, instruction)
    [x1,y1,x2,y2] = Enum.map(coords, &String.to_integer/1)
    perform = case action do
      "on" -> fn x -> x + 1 end
      "off" -> fn x -> case x do 0->0; 1->0; _->x-1 end end
      "toggle" -> fn x -> x + 2 end
    end
    change(grid, 0, x1, y1, x2, y2, perform, [])
  end

  def change([],_,_,_,_,_,_,acc), do: Enum.reverse(acc)
  def change([head|rest], pos, x1, y1, x2, y2, fun, acc) when pos >= y1 and pos <= y2 do
    result = change_line(head, 0, x1, x2, fun, [])
    change(rest, pos+1, x1, y1, x2, y2, fun, [result|acc])
  end
  def change([head|rest], pos, x1, y1, x2, y2, fun, acc) do
    change(rest, pos+1, x1, y1, x2, y2, fun, [head|acc])
  end

  def change_line([],_,_,_,_,acc), do: Enum.reverse(acc)

  def change_line([head|rest], pos, x1, x2, fun, acc) when pos >= x1 and pos <= x2 do
    change_line(rest,pos + 1, x1, x2, fun, [fun.(head)|acc])
  end
  def change_line([head|rest], pos, x1, x2, fun, acc) do
    change_line(rest, pos + 1, x1, x2, fun, [head|acc])
  end

  def count_on(grid) do
    List.flatten(grid) |> Enum.sum
  end
end

row = fn -> for n <- 1..1000, do: 0 end
grid = for n <- 1..1000, do: row.()

#IO.puts A.run_steps(["turn on 0,0 through 0,0"], grid) |> A.count_on
#IO.puts A.run_steps(["toggle 0,0 through 999,999"], grid) |> A.count_on
#IO.puts A.run_steps(["turn on 0,0 through 999,999"], grid) |> A.count_on == 1000000

IO.puts A.run_steps(String.split(File.read!("day6.txt"), "\n"), grid) |> A.count_on


