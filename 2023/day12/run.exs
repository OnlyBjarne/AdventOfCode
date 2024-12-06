defmodule HotSprings do
  @input File.read!("./input.txt")

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [task, numbers] = line |> String.split(" ", trim: true)

      [
        task,
        numbers
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer(&1))
      ]
    end)
  end

  def part1(data \\ @input) do
    data |> parse_data() |> IO.inspect()
  end

  def part2(data \\ @input) do
  end
end

test_data = "
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"

HotSprings.part1(test_data)
