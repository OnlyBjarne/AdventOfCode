defmodule Day3 do
  def find_expressions(expr) do
    Regex.scan(~r"mul\(\d+,\d+\)", expr, return: :index)
  end

  def find_ranges(expr, valid, value, offset) do
    [{i, w} | _] =
      Regex.run(~r"(don't\(\)|do\(\))", expr, return: :index, offset: offset) ||
        [{String.length(expr), 0}]

    case {valid, String.slice(expr, i..(i + w - 1)), i} do
      # End
      {_, "", _} -> [i | value] |> Enum.reverse()
      {false, "don't()", _} -> find_ranges(expr, false, value, i + 1)
      {true, "do()", _} -> find_ranges(expr, true, value, i + 1)
      # From dont to do
      {true, "don't()", _} -> find_ranges(expr, false, [i - 1 | value], i + 1)
      {false, "do()", _} -> find_ranges(expr, true, [i | value], i + 1)
    end
  end

  def multiply(input) do
    [x, y] = String.replace(input, ["mul(", ")"], "") |> String.split(",")

    String.to_integer(x) * String.to_integer(y)
  end

  def part_1(input \\ Common.read_file("./day3.txt")) do
    input
    |> find_expressions()
    |> List.flatten()
    |> Enum.map(fn {i, w} -> String.slice(input, i..(i + w - 1)) end)
    |> Enum.map(&multiply(&1))
    |> Enum.sum()
  end

  def part_2(input \\ Common.read_file("./day3.txt")) do
    expressions =
      input
      |> find_expressions()

    valid_ranges =
      find_ranges(input, true, [0], 0)
      |> Enum.chunk_every(2, 2, :discard)
      |> Enum.map(fn [from, to] -> from..to end)

    expressions
    |> List.flatten()
    |> Enum.filter(fn {i, _} ->
      Enum.any?(valid_ranges, fn range -> i in range end)
    end)
    |> Enum.map(fn {i, w} -> String.slice(input, i..(i + w - 1)) end)
    |> Enum.map(&multiply(&1))
    |> Enum.sum()
  end
end
