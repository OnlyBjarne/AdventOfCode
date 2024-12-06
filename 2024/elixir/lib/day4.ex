defmodule Day4 do
  def find_x_positions(input) do
    Regex.scan(~r/X/, input, return: :index) |> List.flatten()
  end

  def part_1(input \\ Common.read_file("./day4.txt")) do
    input |> find_x_positions()
  end

  def part_2(input \\ Common.read_file("./day4.txt")) do
    nil
  end
end
