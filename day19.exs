defmodule AdventOfCode.Day19.PartOne do
  def process(file, string) do
    data = File.read!(file)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, " => ")))

    t = string |> String.to_char_list
    Enum.reduce(data, [], fn([k,v], acc) ->
      acc ++ substitute([String.to_char_list(k),String.to_char_list(v)], t)
    end) |> Enum.uniq
  end

  def substitute([k,v], data) do
    substitute([k,v], [], data, [])
  end

  def substitute(_, _, [], results), do: results

  def substitute([k,v], processed, unmatched=[h|t], results) do
    cond do
      k === Enum.take(unmatched,length(k)) ->
        rest = (unmatched -- k)
        result = (processed++v++rest)
        #IO.puts "subbing #{k}->#{v}=#{inspect result} | rest=#{inspect rest} processed=#{inspect processed}"
        #[(v ++ rest),k,substitute([k,v], rest)]
        substitute([k,v], List.flatten(processed++[k]), rest, [result|results])
      true ->
        #IO.puts "no sub for #{[h]} | rest=#{inspect t} processed=#{inspect processed}"
        #[h++substitute([k,v], r)]
        substitute([k,v], List.flatten(processed++[h]), t, results)
    end
  end
end

defmodule AdventOfCode.Day19.PartTwo do
  def process(file, string) do
    data = File.read!(file)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&(List.to_tuple(Enum.reverse(String.split(&1, " => ")))))
    |> Enum.sort(fn({x,_},{y,_}) -> String.length(x) > String.length(y) end)
    # now we have an inverse list of substitutions, sorted by length..

    #s = String.reverse(string)
    run(string,data,0)
  end

  def replacements(map,string) do
    Enum.filter(map, fn({find,_}) ->
      String.contains?(string,find)
    end)
  end

  def run("e",_,step) do
    IO.puts "YASSS #{step}"
    step
  end
  def run(string, map, step) do
    cond do
      String.contains?(string, "e") -> nil
      true ->
        replacements(map,string) |> Enum.find(fn({from,to}) ->
          String.replace(string,from,to, global: false) |> run(map, step + 1)
        end)
      end
  end
end

sample = "HOHOHO"
full = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

#AdventOfCode.Day19.PartOne.process("input/day19.full", full) |> Enum.count |> IO.inspect
AdventOfCode.Day19.PartTwo.process("input/day19.full", full)
