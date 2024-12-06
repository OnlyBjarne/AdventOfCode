defmodule Galaxies do
  @input File.read!("./input.txt")

  def parseInput(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def expand_universe(data) do
    empty_rows =
      data
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, y}, acc ->
        if !(row |> Enum.find(false, fn char -> char == "#" end)) do
          [y | acc]
        else
          acc
        end
      end)

    x_length = data |> Enum.at(0) |> length()
    y_length = data |> length()

    empty_cols =
      Enum.filter(0..(x_length - 1), fn x ->
        !Enum.find(0..(y_length - 1), false, fn y -> Enum.at(data, y) |> Enum.at(x) == "#" end)
      end)

    {empty_rows, empty_cols}
  end

  def crossing_expansion({x, y}, {x2, y2}, {rows, cols}) do
    {cols |> Enum.filter(fn col -> x < col && col < x2 end) |> Enum.count(),
     rows |> Enum.filter(fn row -> y < row && row < y2 end) |> Enum.count()}
  end

  def find_galaxies(data) do
    data
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, y}, accY ->
      [
        row
        |> Enum.with_index()
        |> Enum.reduce([], fn {col, x}, accX ->
          case col do
            "#" -> [[{x, y}] | accX]
            _ -> accX
          end
        end)
        | accY
      ]
    end)
    |> List.flatten()
  end

  def find_distances(data, {rows, cols}, times_expansion) do
    data
    |> Enum.with_index()
    |> Enum.flat_map(fn {{x1, y1}, i} ->
      rest = data |> Enum.slice((i + 1)..length(data))

      expansions = times_expansion - 1

      rest
      |> Enum.reduce([], fn {x2, y2}, acc ->
        {x_crosses, y_crosses} =
          crossing_expansion({min(x1, x2), min(y1, y2)}, {max(x1, x2), max(y1, y2)}, {rows, cols})

        [
          abs(x1 - x2) + expansions * x_crosses + abs(y1 - y2) + expansions * y_crosses
          | acc
        ]
      end)
    end)
  end

  def part1(data \\ @input, expand_times \\ 2) do
    input =
      data
      |> parseInput()

    expansions = expand_universe(input) |> IO.inspect()

    galaxies = find_galaxies(input)

    find_distances(galaxies, expansions, expand_times)
  end

  def part2(data \\ @input) do
    part1(data, 1_000_000)
  end
end

test_data = "
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"

Galaxies.part1(test_data) |> Enum.sum() |> IO.inspect(label: "Part 1")
Galaxies.part2() |> Enum.sum() |> IO.inspect(label: "Part 2")
