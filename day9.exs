defmodule AdventOfCode.Day9 do
  def parse(line) do
    Regex.named_captures(~r/(?<a>\w+) to (?<b>\w+) = (?<cost>\d+)/, line)
  end

  def process(path) do
    parsed = File.read!(path) |>
      String.strip |>
      String.split("\n") |>
      Enum.map(&parse/1)

    parsed |>
      flatten(%{}) |>
      build_list |>
      Enum.sort |>
      List.flatten |>
      Enum.sort |>
      List.first |> # Part 1
      #List.last |> # Part 2
      IO.inspect
  end

  def build_list(struct) do
    IO.inspect(struct)
    Dict.to_list(struct) |>
    Enum.map(fn({k, v}) ->
      wanted = Dict.keys(struct) |> List.delete(k)
      build_list(struct, [k], wanted , 0)
    end)
  end

  def build_list(_, cities, [], cost) do
    r = Enum.join(Enum.reverse(cities), " -> ")
    IO.puts "#{r} = #{cost}"
    cost
  end

  def build_list(struct, [city|found], wanted, cost) do
    rest = Dict.get(struct, city)
    Enum.map(wanted, fn x->
      price = Dict.fetch!(rest, x)
      build_list(struct, [x,city|found], List.delete(wanted, x), cost + price)
    end)
  end

  def flatten([], struct), do: struct
  def flatten([head|rest], struct) do
    a = String.to_atom(head["a"])
    b = String.to_atom(head["b"])
    cost = String.to_integer(head["cost"])
    struct = set_city(struct,a,b,cost)
    struct = set_city(struct,b,a,cost)
    flatten(rest,struct)
  end

  defp set_city(struct, a, b, distance) do
    {_, struct} = Dict.get_and_update(struct, a, fn(c) ->
      new = case c do
        nil -> Dict.put(%{}, b, distance)
        _ -> Dict.put(c, b, distance)
      end
      {c, new}
    end)
    struct
  end
end

#AdventOfCode.Day9.process("input/day9.sample")
AdventOfCode.Day9.process("input/day9.full")
