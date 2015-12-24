defmodule AdventOfCode.Day20 do
  def process(presents) do
    #run(presents / 10, fn(_,_) -> true end) # part one
    run(presents / 11, fn(house_no, factor) -> visits=house_no/factor; visits<= 50 end)
  end

  def run(goal, filter) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.find( fn n ->
      t = n |> factorize |> Enum.filter(&filter.(n, &1))
      Enum.sum(t) >= goal
    end)
  end

  def factorize(n) do
    root = n |> :math.sqrt |> round
    IO.puts "#{n} // #{root}"
    (1..root)
    |> Enum.map(fn(x) -> factor(n,x) end)
    |> List.flatten
    #|> IO.inspect
  end

  def factor(a,b) when rem(a, b) != 0, do: []
  def factor(a,b) when b==round(a/b), do: [b]
  def factor(a,b), do: [b, round(a/b)]
end

#o = AdventOfCode.Day20.process(150)
#IO.puts o == 8
IO.inspect AdventOfCode.Day20.process(33100000)


