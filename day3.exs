defmodule A do
  def process(moves) do
    IO.puts "Starting #{moves}"
    moves = String.to_char_list(moves)
    steps = Enum.chunk(moves, 2)
    santa_steps = steps |> Enum.map(fn x -> List.first(x) end)
    robo_steps = steps |> Enum.map(fn x -> List.last(x) end)

    santa_moves = process(santa_steps, [0,0], Set.put(HashSet.new, [0,0]))
    process(robo_steps, [0,0], santa_moves)
  end

  def process([],_,move_history), do: move_history

  def process([move|rest], [x,y], move_history) do
    location = case move do
      ?^ -> [x,y+1]
      ?v -> [x,y-1]
      ?> -> [x+1,y]
      ?< -> [x-1,y]
    end
    process(rest, location, Set.put(move_history, location))
  end
end


#IO.puts A.process(">") == 2
#IO.puts A.process("^>v<") == 4
#IO.puts Set.size(A.process("^v^v^v^v^v")) ==11
IO.puts Set.size(A.process(File.read!("day3.txt")))
