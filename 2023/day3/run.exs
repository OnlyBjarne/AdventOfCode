#
# --- Day 3: Gear Ratios ---
#
# You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you.
# You go inside.
#
# It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.
#
# "Aaah!"
#
# You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! 
# The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.
#
# The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. 
# If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.
#
# The engine schematic (your puzzle input) consists of a visual representation of the engine. 
# There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, 
# is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)
#
# Here is an example engine schematic:
#
test_data_1 =
  "467..114..
...*......
...35..633
......#...
617*......
.....+.58.
..592.....
.......755
...$..*...
.664...598"

test_data_2 = "
467...114.
...*......
.35...633.
......#...
617*......
.....+.583
#.592.....
......755.
..598*....
.664......"

# In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). 
# Every other number is adjacent to a symbol and so is a part number; their sum is 4361.
#
# Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?

defmodule GearRatios do
  @input File.read!("./input.txt")

  @regex ~r/\d+/

  # Finds all number locations 
  def find_location(input_string, regex) do
    Regex.scan(regex, input_string, return: :index) |> List.flatten()
  end

  def is_touching(input_string, {index, length}, line_length, regex \\ ~r/[^.\d\n]/) do
    look_around(input_string, index, length, line_length)
    |> List.flatten()
    |> Enum.dedup()
    |> Enum.any?(fn pos ->
      String.match?(String.slice(input_string, pos, 1), regex)
    end)
  end

  def look_around(input_string, index, length, line_length) do
    new_length = length + 1

    minimum = 0
    maximum = String.length(input_string) - 1

    previous =
      Enum.max([minimum, index - 1 - line_length])..Enum.max([
        minimum,
        index - 1 - line_length + new_length
      ])

    current =
      Enum.max([0, index - 1])..Enum.min([maximum, index - 1 + new_length])

    next =
      Enum.min([maximum, index - 1 + line_length])..Enum.min([
        maximum,
        index - 1 + line_length + new_length
      ])

    [Range.to_list(previous), Range.to_list(current), Range.to_list(next)]
  end

  def part1(input_string \\ @input) do
    line_length =
      input_string
      |> String.split("\n")
      |> List.first()
      |> String.length()

    numbers =
      input_string
      |> find_location(@regex)

    Enum.filter(numbers, fn x ->
      is_touching(input_string, x, line_length + 1)
    end)
    |> Enum.reduce(
      0,
      fn {index, length}, acc ->
        acc + String.to_integer(String.slice(input_string, index, length))
      end
    )
  end

  def part2(input_string \\ @input) do
    line_length =
      (input_string
       |> String.split("\n")
       |> List.first()
       |> String.length()) + 1

    cogs =
      input_string
      |> find_location(~r/\*/)
      |> Enum.filter(fn {index, _l} ->
        touching =
          look_around(input_string, index, 1, line_length)
          |> Enum.map(fn x ->
            [from, _, to] = x

            String.slice(input_string, from..to)
          end)
          |> Enum.join("\n")

        scans = Regex.scan(~r/\d+/, touching)

        count =
          scans |> Enum.count()

        count == 2
      end)

    # cogs is a list of locations of cogs with 2 touching numbers [{1,1},{19,0}]

    numbers_with_range =
      input_string
      |> find_location(~r/\d+/)
      |> Enum.filter(fn x ->
        is_touching(input_string, x, line_length, ~r/\*/)
      end)
      |> Enum.map(fn {index, length} ->
        [
          String.to_integer(String.slice(input_string, index, length)),
          look_around(input_string, index, length, line_length) |> List.flatten() |> Enum.dedup()
        ]
      end)

    cogs
    |> Enum.reduce(0, fn {index, _}, acc ->
      [first, second] =
        Enum.filter(numbers_with_range, fn [number, range] ->
          if Enum.member?(range, index) do
            true
          else
            false
          end
        end)
        |> Enum.map(fn [n, _] -> n end)
        |> IO.inspect()

      acc + first * second
    end)
  end
end

# GearRatios.part1(test_data_2) |> IO.inspect()

# (GearRatios.part1() == 554_003) |> IO.inspect(label: "part1")
# GearRatios.part2(test_data_2 |> String.trim()) |> IO.inspect() |> (&IO.puts(&1 == 467_835)).()
# GearRatios.part2() |> IO.inspect()

_ = 14_758_247
_ = 82_785_014
# |> IO.inspect()

# |> IO.inspect(label: "part2")
