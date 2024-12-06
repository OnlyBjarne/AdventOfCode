defmodule Day16 do
  @input File.read!("./input.txt")

  def draw_path(path, grid) do
    path
    |> Enum.reduce(grid, fn {x, y}, acc ->
      List.replace_at(acc, y, List.replace_at(Enum.at(acc, y), x, "#")) |> IO.inspect()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.codepoints()
    end)
  end

  def p1(data \\ @input) do
    grid =
      data
      |> parse_data()

    start = {0, 0, "R"}

    results =
      move(start, grid, [])
      |> List.flatten()
      |> Enum.map(fn {x, y, _dir} -> {x, y} end)
      |> Enum.uniq()
      |> Enum.count()

    # |> draw_path(grid)
  end

  def move(coord_and_dir, grid, paths) do
    {x, y, dir} = coord_and_dir

    width = (grid |> Enum.at(0) |> length()) - 1
    height = (grid |> length()) - 1
    current_symbol = grid |> Enum.at(y, []) |> Enum.at(x, "")

    if {x, y, dir} in paths do
      paths
    else
      case {x, y, dir, current_symbol} do
        {x, y, d, symbol} when x < 0 or x > width ->
          paths

        {x, y, d, symbol} when y < 0 or y > height ->
          paths

        {x, y, "D", "-"} ->
          left = move({x - 1, y, "L"}, grid, [{x, y, dir} | paths])
          move({x + 1, y, "R"}, grid, [{x, y, dir} | left])

        {x, y, "U", "-"} ->
          left = move({x - 1, y, "L"}, grid, [{x, y, dir} | paths])
          move({x + 1, y, "R"}, grid, [{x, y, dir} | left])

        {x, y, "L", "|"} ->
          up = move({x, y - 1, "U"}, grid, [{x, y, dir} | paths])
          move({x, y + 1, "D"}, grid, [{x, y, dir} | up])

        {x, y, "R", "|"} ->
          up = move({x, y - 1, "U"}, grid, [{x, y, dir} | paths])
          move({x, y + 1, "D"}, grid, [{x, y, dir} | up])

        {x, y, "L", "\\"} ->
          move({x, y - 1, "U"}, grid, [{x, y, dir} | paths])

        {x, y, "L", "/"} ->
          move({x, y + 1, "D"}, grid, [{x, y, dir} | paths])

        {x, y, "L", _} ->
          move({x - 1, y, "L"}, grid, [{x, y, dir} | paths])

        {x, y, "R", "\\"} ->
          move({x, y + 1, "D"}, grid, [{x, y, dir} | paths])

        {x, y, "R", "/"} ->
          move({x, y - 1, "U"}, grid, [{x, y, dir} | paths])

        {x, y, "R", _} ->
          move({x + 1, y, "R"}, grid, [{x, y, dir} | paths])

        {x, y, "U", "/"} ->
          move({x + 1, y, "R"}, grid, [{x, y, dir} | paths])

        {x, y, "U", "\\"} ->
          move({x - 1, y, "L"}, grid, [{x, y, dir} | paths])

        {x, y, "U", _} ->
          move({x, y - 1, "U"}, grid, [{x, y, dir} | paths])

        {x, y, "D", "\\"} ->
          move({x + 1, y, "R"}, grid, [{x, y, dir} | paths])

        {x, y, "D", "/"} ->
          move({x - 1, y, "L"}, grid, [{x, y, dir} | paths])

        {x, y, "D", _} ->
          move({x, y + 1, "D"}, grid, [{x, y, dir} | paths])
      end
    end
  end

  def p2(data \\ @input) do
    grid =
      data
      |> parse_data()

    height = length(grid) - 1
    width = (grid |> Enum.at(0) |> Enum.count()) - 1

    starts =
      Enum.map(
        0..height,
        fn y ->
          Enum.map(0..width, fn x ->
            case {x, y} do
              {0, 0} ->
                [{x, y, "D"}, {x, y, "R"}, {width, height, "U"}, {width, height, "L"}]

              {0, y} ->
                [{x, y, "R"}, {width, y, "L"}]

              {x, 0} ->
                [{x, y, "D"}, {x, height, "U"}]

              _ ->
                {x, y, "_"}
            end
          end)
        end
      )
      |> List.flatten()
      |> Enum.filter(fn {_x, _y, dir} -> dir !== "_" end)

    results =
      Enum.map(
        starts,
        fn start ->
          move(start, grid, [])
          |> List.flatten()
          |> Enum.map(fn {x, y, _dir} -> {x, y} end)
          |> Enum.uniq()
          |> Enum.count()
          |> IO.inspect()
        end
      )
      |> Enum.max()

    # |> draw_path(grid)
  end
end

test_data = File.read!("./input_test.txt")

# Day16.p1() |> IO.inspect(label: "part 1")
Day16.p2() |> IO.inspect(label: "part 1")
