defmodule Day18 do
  @input File.read!("./input.txt")

  def parse_input(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [dir, steps, color] = String.split(line, " ", trim: true)

      {dir, String.to_integer(steps), String.slice(color, 1..-2)}
    end)
  end

  def hex_to_coordinates(data) do
    data
    |> Enum.map(fn {dir, steps, color} ->
      {hexstring, directionsign} = color |> String.split_at(-1)
      hex_number = String.to_integer(String.slice(hexstring, 1..-1), 16)

      case directionsign do
        "0" -> {"R", hex_number, color}
        "1" -> {"D", hex_number, color}
        "2" -> {"L", hex_number, color}
        "3" -> {"U", hex_number, color}
      end
    end)
  end

  def create_coordinates(data) do
    data
    |> Enum.reduce([{0, 0}], fn {dir, steps, _color}, acc ->
      last_item = hd(acc)
      x = elem(last_item, 0)
      y = elem(last_item, 1)

      case dir do
        "U" -> [{x, y - steps} | acc]
        "R" -> [{x + steps, y} | acc]
        "D" -> [{x, y + steps} | acc]
        "L" -> [{x - steps, y} | acc]
      end
    end)
    |> Enum.reverse()
  end

  def outline_length(data) do
    data
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      abs(x1 - x2) + abs(y1 - y2)
    end)
    |> Enum.sum()
  end

  def calculate_area(data) do
    area =
      data
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn chunk ->
        if chunk |> Enum.count() > 1 do
          [{x1, y1}, {x2, y2}] = chunk
          x1 * y2 - y1 * x2
        else
          [{x1, y1}] = chunk
          {x2, y2} = {0, 0}
          x1 * y2 - y1 * x2
        end
      end)
      # add area of outline
      |> Enum.sum()
      |> div(2)
      |> abs()

    # include starting block again 
    area + outline_length(data) / 2 + 1
  end

  def p1(data \\ @input) do
    data
    |> parse_input()
    |> create_coordinates()
    |> calculate_area()
  end

  def p2(data \\ @input) do
    data
    |> parse_input()
    |> hex_to_coordinates()
    |> create_coordinates()
    |> calculate_area()
    |> round()
  end
end

test_input = "
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)"

# Day18.p1() |> IO.inspect(label: "Part1")
Day18.p2() |> IO.inspect(label: "Part2")
