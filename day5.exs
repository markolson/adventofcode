defmodule A do
  def has_enough_vowels?(s) do
    String.length(String.replace(s, ~r/[^aeiou]/, "")) >= 3
  end

  def has_double_letter?(s) do
    has_double_letter?(String.to_char_list(s), false)
  end

  def has_double_letter?([], found), do: found
  def has_double_letter?([_], found), do: found

  def has_double_letter?([a,b|rest], found) do
    has_double_letter?([b|rest], (found || a == b))
  end

  def banned?(s) do
    String.contains?(s, ["ab", "cd", "pq", "xy"])
  end

  def nice?(s) do
    !banned?(s) && has_double_letter?(s) && has_enough_vowels?(s)
  end
end

defmodule B do
  def has_double_pairs?(s) do
    has_double_pairs?(String.to_char_list(s), false)
  end
  def has_double_pairs?([],found), do: found
  def has_double_pairs?([_], found), do: found
  def has_double_pairs?([a,b|rest], found) do
    if has_double_pair?(rest, [a,b], false) do
      has_double_pairs?(rest, true)
    else
      has_double_pairs?([b|rest], found)
    end
  end


  def has_double_pair?([], _, found), do: found
  def has_double_pair?([_], _, found), do: found
  def has_double_pair?([a,b|rest], [], found) do
    has_double_pair?(rest, [a,b], found)
  end
  def has_double_pair?([a,b|rest], [c,d], found) do
    #IO.puts("#{a}==#{c},#{b}==#{d}")
    has_double_pair?([b|rest], [c,d], (found || (a==c && b==d)))
  end

  def has_spaced_pair?(s) do
    has_spaced_pair?(String.to_char_list(s), false)
  end
  def has_spaced_pair?([], found), do: found
  def has_spaced_pair?([_], found), do: found
  def has_spaced_pair?([_,_], found), do: found
  def has_spaced_pair?([a,b,c|rest], found) do
    has_spaced_pair?([b,c|rest], (found || a == c))
  end

  def nice?(s) do
    B.has_double_pairs?(s) && B.has_spaced_pair?(s)
  end
end

IO.puts A.nice?("aaa") == true
IO.puts A.nice?("ugknbfddgicrmopn") == true
IO.puts A.nice?("jchzalrnumimnmhp") == false
IO.puts A.nice?("haegwjzuvuyypxyu") == false
IO.puts A.nice?("dvszwmarrgswjxmb") == false

IO.puts B.nice?("qjhvhtzxzqqjkmpb") == true
IO.puts B.nice?("xxyxx") == true
IO.puts B.nice?("uurcxstgmygtbstg") == false
IO.puts B.nice?("ieodomkazucvgmuy") == false

IO.puts File.read!("day5.txt") |> String.split |> Enum.filter(&A.nice?/1) |> length
IO.puts File.read!("day5.txt") |> String.split |> Enum.filter(&B.nice?/1) |> length
