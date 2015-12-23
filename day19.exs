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

sample = "HOH"
full = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

AdventOfCode.Day19.PartOne.process("input/day19.full", full) |> Enum.count |> IO.inspect
