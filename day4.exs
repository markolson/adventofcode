defmodule Crypto do
  def md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end
end

defmodule A do
  def valid(s) do
    String.match?(Crypto.md5(s), ~r/^000000/)
  end

  def process, do: process(0)
  def process(i) do
    key = "ckczppom"
    IO.puts i
    unless valid("#{key}#{i}"), do: process(i+1)
  end
end
