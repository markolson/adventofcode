defmodule AdventOfCode.Day19 do
  def process(file, string) do
    data = File.read!(file)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, " => ")))

    t = string |> String.to_char_list
    Enum.map(data, fn([k,v]) ->
      substitute([String.to_char_list(k),String.to_char_list(v)], t)
    end)
  end

  def substitute(_, _, []), do: []
  def substitute([k,v], main_list) do
    rest = (main_list -- k)
    IO.inspect [main_list, rest]
    cond do
      k === Enum.take(main_list,length(k)) ->
        IO.puts "subbing #{k} | #{(v ++ rest)}"
        [(v ++ rest)|(v ++substitute([k,v], rest))]
      true ->
        #IO.puts "no sub for #{hd(main_list)}"
        [hd(main_list)|substitute([k,v], tl(main_list))]
    end
  end
end

sample = "HOH"
#full = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

IO.inspect AdventOfCode.Day19.process("input/day19.sample", sample)
#IO.inspect AdventOfCode.Day19.process("input/day19.full", full)
