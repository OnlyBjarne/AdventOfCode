test_data = "
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

defmodule Day13 do
  @input File.read!("./input.txt")

  def parse_input(data) do
    data
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn blocks ->
      blocks
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
    end)
  end

  def find_mirror_row(block, {from, to}) do
    above =
      Enum.slice(block, 0..(to - 1)) |> Enum.reverse()

    below =
      Enum.slice(block, to..(length(block) - 1))

    above = above |> Enum.slice(0..(length(below) - 1)) |> IO.inspect(label: "above")
    below = below |> Enum.slice(0..(length(above) - 1)) |> IO.inspect(label: "below")

    is_mirror =
      above == below

    cond do
      length(below) < 1 ->
        nil

      is_mirror ->
        to |> IO.inspect(label: "Mirror found")

      true ->
        find_mirror_row(block, {from, to + 1})
    end
  end

  def find_smudge_row(block, {from, to}) do
    above =
      Enum.slice(block, 0..(to - 1)) |> Enum.reverse()

    below =
      Enum.slice(block, to..(length(block) - 1))

    above = above |> Enum.slice(0..(length(below) - 1))
    below = below |> Enum.slice(0..(length(above) - 1))

    is_mirror =
      Enum.zip(above, below)
      |> Enum.flat_map(fn {x, y} ->
        Enum.zip(x, y)
        |> IO.inspect()
        |> Enum.map(fn {x, y} ->
          if(x == y) do
            0
          else
            1
          end
        end)
      end)
      |> Enum.sum() == 1

    cond do
      length(below) < 1 ->
        nil

      is_mirror ->
        to |> IO.inspect(label: "Smudge found found")

      true ->
        find_smudge_row(block, {from, to + 1})
    end
  end

  def p1(data \\ @input) do
    parsed_data = data |> parse_input()

    parsed_data
    |> Enum.flat_map(fn b ->
      col = find_mirror_row(Enum.zip(b) |> Enum.map(fn x -> x |> Tuple.to_list() end), {0, 1})
      row = find_mirror_row(b, {nil, 1})
      [{col, "c"}, {row, "r"}]
    end)
    |> Enum.reduce(0, fn {value, dir}, acc ->
      case {value, dir} do
        {nil, _} -> acc
        {value, "r"} -> acc + value * 100
        {value, "c"} -> acc + value
      end
    end)
  end

  def p2(data \\ @input) do
    parsed_data = data |> parse_input()

    parsed_data
    |> Enum.map(fn b ->
      col = find_smudge_row(Enum.zip(b) |> Enum.map(fn x -> x |> Tuple.to_list() end), {0, 1})

      if col !== nil do
        {col, "c"}
      else
        row =
          find_smudge_row(b, {0, 1})

        {row, "r"}
      end
    end)
    |> Enum.reduce(0, fn {value, dir}, acc ->
      case {value, dir} do
        {nil, _} -> acc
        {value, "r"} -> acc + value * 100
        {value, "c"} -> acc + value
      end
    end)
  end
end

test_data2 = "
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#

.#.##.#.#
.##..##..
.#.##.#..
#......##
#......##
.#.##.#..
.##..##.#

#..#....#
###..##..
.##.#####
.##.#####
###..##..
#..#....#
#..##...#

#.##..##.
..#.##.#.
##..#...#
##...#..#
..#.##.#.
..##..##.
#.#.##.#."

# Day13.p1(test_data) |> IO.inspect(label: "part1", charlists: :as_lists)
Day13.p2() |> IO.inspect(label: "part2", charlists: :as_lists)
