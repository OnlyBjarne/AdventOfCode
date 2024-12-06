defmodule Day14 do
  @input File.read!("./input.txt")

  def parse_input(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([",", "@"], trim: true)
      |> Enum.map(fn num -> String.to_integer(String.trim(num)) end)
    end)
  end

  def position_delta(coords, time) do
    [px, py, pz, dx, dy, dz] = coords
    [px + dx * time, py + dy * time, pz + dz * time]
  end

  def p1(data \\ @input) do
    data
    |> parse_input()
    |> Enum.map(fn coord -> position_delta(coord, 7) end)
  end

  def p2(data \\ @input) do
    data
  end
end

test_input = "
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
"

Day14.p1(test_input) |> IO.inspect(label: "Part 1")
