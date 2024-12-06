defmodule Day14 do
  @input File.read!("./input.txt")

  def parse_data(data) do
    rows =
      data
      |> String.split("\n", trim: true)

    height = length(rows)

    width = rows |> Enum.at(0) |> String.length()

    %{
      :height => height,
      :width => width,
      :parsed => Enum.join(rows, "")
    }
  end

  def move_rocks(data, width, height) do
    Regex.scan(~r/O/, data, return: :index)
    |> List.flatten()
    |> Enum.reduce(data, fn {i, _}, acc ->
      as_list = acc |> String.codepoints()

      if i - width < 0 do
        acc
      else
        current = as_list |> Enum.at(i)
        above = Enum.at(as_list, i - width)

        case above do
          "." ->
            as_list
            |> List.replace_at(i, above)
            |> List.replace_at(i - width, current)
            |> Enum.join("")

          _ ->
            acc
        end
      end
    end)
  end

  def p1(data \\ @input) do
    res = data |> parse_data()

    move_rocks(res[:parsed], res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> move_rocks(res[:width], res[:height])
    |> String.codepoints()
    |> Enum.chunk_every(res[:width])
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, index}, acc ->
      count_in_row =
        row
        |> Enum.filter(fn x -> x == "O" end)
        |> Enum.count()

      acc + count_in_row * (res[:height] - index)
    end)
  end
end

test_data = "
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."

Day14.p1() |> IO.inspect(label: "Part 1")
