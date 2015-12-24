defmodule Comb do
  def combinations(enum, k) do
    List.last(do_combinations(enum, k))
    |> Enum.uniq
  end

  defp do_combinations(enum, k) do
    combinations_by_length = [[[]]|List.duplicate([], k)]

    list = Enum.to_list(enum)
    List.foldr list, combinations_by_length, fn x, next ->
      sub = :lists.droplast(next)
      step = [[]|(for l <- sub, do: (for s <- l, do: [x|s]))]
      :lists.zipwith(&:lists.append/2, step, next)
    end
  end
end

defmodule AdventOfCode.Day24.TryTwo do
  def process(file) do
    File.read!(file)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort
  end

  def run(data,x) do
    goal_weight = div(Enum.sum(data),x)
    fill_a_container(data, goal_weight)
  end

  def fill_a_container(data, goal_weight) do
    # stop once we find a valid answer. I'm assuming that
    # by generating the combinations shortest to longest,
    # when we find a valid short combination (using a sorted list)
    # it'll be the one with the smallest product.

    # I guess I'm also
    # assuming that if I find one answers, the other containers
    # will even out.... ... ...
    Enum.find(1..length(data), fn(x) ->
      # get each combination of a length
      x = Comb.combinations(data,x) |>
      # find the first one that matches our weight
      Enum.find(fn(x) -> Enum.sum(x) ==  goal_weight end)
      case x do
        nil -> nil # if there are none, carry one
        # otherwise print out a result
        _ -> Enum.reduce(x, 1,fn(a,t) -> a*t end) |> IO.inspect
      end
    end)
  end
end

AdventOfCode.Day24.TryTwo.process("input/day24.full")
|> AdventOfCode.Day24.TryTwo.run(5)
