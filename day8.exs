defmodule A do
  def string_values(s) do
    s = s |> String.strip(?") |> String.replace("\\\"", "\"")
    s |> hex_to_char |> String.length
  end

  def hex_to_char(s) do
    String.replace(s, ~r/\\x\d\d/, "a")
  end
end

lines = [~s(""), ~s("abc"), ~s("aaa\"aaa"), ~s("\x27")]

read = File.read!("day8.txt")
lines = read |> String.strip |> String.split("\n")
IO.puts entries = Enum.count(lines)
%{size: size} = File.stat!("day8.txt")
IO.puts size - entries
IO.puts total = Enum.map(lines, &A.string_values/1) |> Enum.sum
IO.puts (size - entries) - total


{c_size, m_size} = Enum.reduce(File.stream!("day8-2.txt"), {0, 0}, fn line, {c_size, m_size} ->
    line = String.strip(line)
    {ret, _ } = Code.eval_string(line)
    {c_size + String.length(line), m_size + String.length(ret)}
end)
IO.puts "Part 1: #{c_size - m_size}"

{c_size, nc_size} = Enum.reduce(File.stream!("day8.txt"), {0, 0}, fn line, {c_size, nc_size} ->
    line = String.strip(line)
    new_code = Macro.to_string(quote do: unquote(line))
    {c_size + String.length(line), nc_size + String.length(new_code)}
end)
IO.puts "Part 2: #{nc_size - c_size}"
