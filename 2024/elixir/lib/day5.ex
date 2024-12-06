defmodule Day5 do
  def test_cases([], _), do: true

  def test_cases([[left, right] | rest], rule) do
    leftIndex = rule |> Enum.find_index(fn val -> val == left end)
    rightIndex = rule |> Enum.find_index(fn val -> val == right end)

    case {leftIndex, rightIndex} do
      {nil, _} -> test_cases(rest, rule)
      {_, nil} -> test_cases(rest, rule)
      {l, r} when l < r -> test_cases(rest, rule)
      {l, r} when l >= r -> false
    end
  end

  def test_cases_fix([], res, _), do: res

  def test_cases_fix([[left, right] | rest], rule, start) do
    leftIndex = rule |> Enum.find_index(fn val -> val == left end)
    rightIndex = rule |> Enum.find_index(fn val -> val == right end)

    case {leftIndex, rightIndex} do
      {nil, _} ->
        test_cases_fix(rest, rule, start)

      {_, nil} ->
        test_cases_fix(rest, rule, start)

      {l, r} when l < r ->
        test_cases_fix(rest, rule, start)

      {l, r} when l >= r ->
        test_cases_fix(start, swap_rule(rule, leftIndex, rightIndex), start)
    end
  end

  def swap_rule(rule, left, right) do
    i1 = rule |> Enum.at(left)
    i2 = rule |> Enum.at(right)

    rule
    |> List.replace_at(left, i2)
    |> List.replace_at(right, i1)
  end

  def get_middle(input) do
    String.to_integer(Enum.at(input, ceil(length(input) / 2) - 1))
  end

  def build_order_tree(input) do
    input
    |> Enum.reduce(%{}, fn [left, right], acc ->
      Map.update(acc, left, [], fn val -> [right | val] end)
    end)
  end

  def part_1(input \\ Common.read_file("./day5.txt")) do
    [ordering_rules, rules] = input |> String.split("\n\n")

    rules = rules |> Common.to_lines() |> Enum.map(&String.split(&1, ","))

    ordering_rules =
      ordering_rules
      |> Common.to_lines()
      |> Enum.map(&String.split(&1, "|"))

    rules |> Enum.filter(&test_cases(ordering_rules, &1)) |> Enum.map(&get_middle/1) |> Enum.sum()
  end

  def part_2(input \\ Common.read_file("./day5.txt")) do
    [ordering_rules, rules] = input |> String.split("\n\n")

    rules = rules |> Common.to_lines() |> Enum.map(&String.split(&1, ","))

    ordering_rules =
      ordering_rules
      |> Common.to_lines()
      |> Enum.map(&String.split(&1, "|"))

    rules
    |> Enum.filter(&(!test_cases(ordering_rules, &1)))
    |> Enum.map(&test_cases_fix(ordering_rules, &1, ordering_rules))
    |> Enum.map(&get_middle/1)
    |> Enum.sum()
    |> IO.inspect(label: "Part 2")
  end
end
