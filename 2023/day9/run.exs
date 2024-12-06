test_data = "0 3 6 9 12 15

1 3 6 10 15 21
10 13 16 21 30 45"

defmodule MirageMaintenance do
  @input File.read!("./input.txt")

  def parse_input(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, " ") |> Enum.map(fn x -> String.to_integer(x) end)))
  end

  def compare_items([head | rest], result) do
    if Enum.count(rest) == 0 do
      result
    else
      compare_items(rest, result ++ [hd(rest) - head])
    end
  end

  def create_row(line, result) do
    new_line = compare_items(line, [])
    new_result = result ++ [new_line]

    if Enum.all?(new_line, fn x -> x == 0 end) do
      new_result
    else
      create_row(new_line, new_result)
    end
  end

  def create_new_history(rows, result, sign \\ -1) do
    rows
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, index}, prev ->
      List.last(row) - prev * sign
    end)
  end

  def part1(data \\ @input) do
    data
    |> parse_input()
    |> Enum.map(&create_row(&1, [&1]))
    |> Enum.map(&create_new_history(&1, [&1], -1))
    |> Enum.sum()
  end

  def part2(data \\ @input) do
    data
    |> parse_input()
    |> Enum.map(&create_row(&1, [&1]))
    |> Enum.map(fn x ->
      Enum.map(x, fn y -> y |> Enum.reverse() end)
    end)
    |> Enum.map(&create_new_history(&1, [&1], 1))
    |> Enum.sum()
  end
end

MirageMaintenance.part1() |> IO.inspect(label: "Task 1 ")
MirageMaintenance.part2() |> IO.inspect(label: "Task 2 ")
