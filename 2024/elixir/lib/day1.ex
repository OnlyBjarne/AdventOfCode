defmodule Day1 do
  def create_lists(lines) do
    lines
    |> Enum.map(&String.split(&1))
    |> Enum.reduce([[], []], fn [a, b], [left, right] ->
      [[String.to_integer(a) | left], [String.to_integer(b) | right]]
    end)
  end

  def sort_lists([first, second]) do
    [first |> Enum.sort(), second |> Enum.sort()]
  end

  def calculate_distance(input) do
    input
    |> Enum.zip()
    |> Enum.reduce(0, fn {left, right}, acc ->
      acc + abs(left - right)
    end)
  end

  def part1(input \\ Common.read_file()) do
    input |> Common.to_lines() |> create_lists() |> sort_lists() |> calculate_distance()
  end

  def part_2(input \\ Common.read_file()) do
    [left, right] = input |> Common.to_lines() |> create_lists()

    left
    |> Enum.reduce(0, fn elem, acc ->
      elem * Enum.count(right, fn el -> el == elem end) + acc
    end)
  end
end
