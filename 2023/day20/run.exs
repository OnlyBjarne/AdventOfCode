defmodule Conjuction do
  defstruct(name, state: false, inputs: %{}, outputs: [])
end

defmodule FlipFlop do
  defstruct(name, state: false, outputs: [])

  def toggle(current, state) do
    case state do
      :low -> %{current | state: !current.state}
      _ -> current
    end
  end
end

defmodule Day20 do
  @input File.read!("./input.txt")
  def parse_input(data) do
    data
    |> String.split(["\n", " -> "], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [key, values] ->
      {key |> String.replace(["%"], ""), values |> String.split(",", trim: true)}
    end)
    |> Map.new()
  end

  def p1(data \\ @input) do
    data |> parse_input()
  end

  def p2(data \\ @input) do
    nil
  end
end

test_data = "
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a"

Day20.p1(test_data) |> IO.inspect(label: "Part1")
