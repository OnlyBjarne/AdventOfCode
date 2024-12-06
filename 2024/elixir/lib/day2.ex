defmodule Day2 do
  def check_direction(input) do
    left = input |> List.first()
    right = input |> List.last()

    cond do
      left < right -> 1
      left == right -> 0
      left > right -> -1
    end
  end

  def safe?(report) do
    diff = report |> Enum.chunk_every(2, 1, :discard) |> Enum.map(fn [a, b] -> b - a end)

    inc = Enum.all?(diff, &(&1 in 1..3))
    dec = Enum.all?(diff, &(&1 in -3..-1))

    inc || dec
  end

  def almost_safe?(report) do
    report
    |> Enum.with_index()
    |> Enum.any?(fn {_, idx} ->
      report |> List.delete_at(idx) |> safe?()
    end)
  end

  def part_1(input \\ Common.read_file("./day2.txt")) do
    input =
      input
      |> Common.to_lines()
      |> Enum.map(fn line ->
        String.split(line) |> Enum.map(fn i -> String.to_integer(i) end)
      end)

    input |> Enum.filter(fn line -> safe?(line) end) |> Enum.count()
  end

  def part_2(input \\ Common.read_file("./day2.txt")) do
    input
    |> Common.to_lines()
    |> Enum.map(&(String.split(&1) |> Enum.map(fn i -> String.to_integer(i) end)))
    |> Enum.filter(fn x -> almost_safe?(x) end)
    |> Enum.count()
  end
end
