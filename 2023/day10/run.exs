defmodule PipeMaze do
  require Integer
  @input File.read!("./input.txt")

  def parse_input(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  end

  def find_start(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.find_value(fn {row, y} ->
      x = row |> Enum.find_index(fn col -> col == "S" end)
      if x != nil, do: {x, y}
    end)
  end

  def get_next_possible(current) do
    case current do
      "N" -> "S"
      "S" -> "N"
      "E" -> "W"
      "W" -> "E"
      _ -> ""
    end
  end

  def symbol_to_letters(symbol) do
    case symbol do
      "|" -> "NS"
      "-" -> "EW"
      "L" -> "NE"
      "J" -> "NW"
      "7" -> "WS"
      "F" -> "ES"
      "." -> ""
      "S" -> ""
    end
  end

  def walk({x, y, previous_direction}, matrix, steps \\ []) do
    value =
      matrix
      |> Enum.at(y)
      |> Enum.at(x)
      |> symbol_to_letters()

    next_possible =
      String.replace(value, previous_direction, "")

    cond do
      !value ->
        steps

      not String.contains?(value, next_possible) ->
        steps

      true ->
        case next_possible do
          "N" -> walk({x, y - 1, "S"}, matrix, [{x, y - 1, "S"} | steps])
          "S" -> walk({x, y + 1, "N"}, matrix, [{x, y + 1, "N"} | steps])
          "E" -> walk({x + 1, y, "W"}, matrix, [{x + 1, y, "W"} | steps])
          "W" -> walk({x - 1, y, "E"}, matrix, [{x - 1, y, "E"} | steps])
          _ -> steps
        end
    end
  end

  def part1(data \\ @input) do
    parsed_data = data |> parse_input
    {x, y} = find_start(parsed_data)

    initial_pos = [{x, y - 1, "S"}, {x, y + 1, "N"}, {x - 1, y, "E"}, {x + 1, y, "W"}]

    # (walk({x + 1, y, "W"}, parsed_data, 0) / 2) |> ceil()

    loop_size =
      initial_pos
      |> Enum.map(fn pos ->
        walk(pos, parsed_data, []) |> Enum.count()
      end)
      |> Enum.max()

    (loop_size / 2) |> ceil()
  end

  def part2(data \\ @input) do
    parsed_data = data |> parse_input()
    {x, y} = find_start(parsed_data)

    initial_pos = [{x, y - 1, "S"}, {x, y + 1, "N"}, {x - 1, y, "E"}, {x + 1, y, "W"}]

    loop_sorted =
      initial_pos
      |> Enum.map(fn pos ->
        walk(pos, parsed_data, [{x, y, "S"}, pos])
      end)
      |> Enum.max_by(fn loop -> loop |> Enum.count() end)
      |> IO.inspect(limit: :infinity)

    open_spaces =
      parsed_data
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, y}, acc ->
        [
          row
          |> Enum.with_index()
          |> Enum.reduce([], fn {col, x}, acc2 ->
            exists =
              loop_sorted
              |> Enum.find(fn {x1, y1, _} -> x1 == x and y1 == y end)

            if exists == nil do
              [{x, y} | acc2]
            else
              acc2
            end
          end)
          | acc
        ]
      end)
      |> List.flatten()

    open_spaces
    |> Enum.reverse()
    |> Enum.filter(fn {x, y} ->
      current_row = parsed_data |> Enum.at(y) |> Enum.slice(0..x)

      current_row
      |> Enum.with_index()
      |> Enum.filter(fn {symbol, x1} ->
        Enum.find(loop_sorted, nil, fn {lx, ly, _} -> lx == x1 and ly == y end) !=
          nil
      end)
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.reduce({0, ""}, fn current, {count, string} ->
        last_prev = String.last(string)

        case [last_prev, current |> IO.inspect()] do
          [nil, x] -> {count + 1, string <> current}
          ["F", "J"] -> {count, string <> current}
          ["F", "7"] -> {count - 1, string <> current}
          ["L", "7"] -> {count, string <> current}
          ["L", "J"] -> {count - 1, string <> current}
          [x, "F"] -> {count + 1, string <> current}
          [x, "|"] -> {count + 1, string <> current}
          [x, "J"] -> {count + 1, string <> current}
          [x, "7"] -> {count + 1, string <> current}
          [x, "L"] -> {count + 1, string <> current}
          [x, "S"] -> {count + 1, string <> current}
          _ -> {count, string}
        end
      end)
      |> IO.inspect()
      |> elem(0)
      |> Integer.is_odd()
    end)

    # |> Enum.count()
  end
end

test_data = ".....
.S-7.
.|.|.
.L-J.
....."

test_data2 = "
..F7.
.FJ|.
SJ.L7
|F--J
LJ..."

# 4
test_data3 = "
..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
.........."

# 8
test_data4 = "
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ..."

# 10
test_data5 = "
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L"

# PipeMaze.part1() |> IO.inspect(label: "Part1")
PipeMaze.part2() |> Enum.count() |> IO.inspect(label: "Part2")
