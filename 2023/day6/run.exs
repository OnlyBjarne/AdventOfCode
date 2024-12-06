test_data = [{7, 9}, {15, 40}, {30, 200}]
test_datas2 = [{71530, 940_200}]

defmodule WaitForIt do
  @input [{41, 244}, {66, 1047}, {72, 1228}, {66, 1040}]

  def calculate_distance(time_total, hold_time) do
    speed = time_total - hold_time
    speed * hold_time
  end

  def part1(data \\ @input) do
    data
    |> Enum.map(fn {total_time, distance} ->
      time_start =
        Enum.find_index(1..(total_time - 1), fn hold_time ->
          calculate_distance(total_time, hold_time) > distance
        end) + 1

      time_end =
        total_time -
          Enum.find_index(1..(total_time - 1), fn hold_time ->
            calculate_distance(total_time, total_time - hold_time) > distance
          end) - 1

      time_start..time_end |> Range.size()
    end)
  end

  @input2 [{41_667_266, 2_441_047_122_81_040}]
  def part2(data \\ @input2) do
    data |> part1()
  end
end

WaitForIt.part1() |> Enum.product() |> IO.inspect()
WaitForIt.part2() |> IO.inspect()
