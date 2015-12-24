defmodule AdventOfCode.Day23 do
  require Integer
  import Dict, [:update!, 2, :fetch!, 2]

  @initial_registers %{"a" => 0, "b" => 0}

  def process(path) do
    File.read!(path)
    |> String.strip
    |> String.split("\n")
    |> Enum.reduce([], fn(inst,acc) ->
      [(String.split(inst, ~r/,{0,1}\s/) |> List.to_tuple)|acc]
    end)
    |> Enum.reverse
  end

  def run(program) do
    run(0, program, @initial_registers)
  end

  def run(instruction, program, registers) do
    case Enum.fetch(program, instruction) do
      :error -> registers
      {:ok, asm} ->
        {mv, reg} = run_asm(asm, registers)
        run(instruction+mv,program,reg)
    end
  end

  def run_asm({"inc", r}, mem), do: {1, update!(mem, r, &(&1+1))}
  def run_asm({"hlf", r}, mem), do: {1, update!(mem, r, &(round(&1 / 2)))}
  def run_asm({"tpl", r}, mem), do: {1, update!(mem, r, &(&1 * 3))}

  def run_asm({"jmp", jmp}, mem), do: j(jmp,mem)

  def run_asm({"jie", r, jmp}, mem) do
    if rem(round(fetch!(mem, r)),2)==0, do: j(jmp,mem), else: j(1,mem)
  end

  def run_asm({"jio", r, jmp}, mem) do
    if fetch!(mem, r)==1, do: j(jmp,mem), else: j(1,mem)
  end

  defp j(v,r) when is_binary(v), do: {String.to_integer(v), r}
  defp j(v,r), do: {v,r}
end

program = AdventOfCode.Day23.process("input/day23.full")
IO.inspect program

IO.inspect AdventOfCode.Day23.run(program)

