defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  @input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "runs on example" do
    assert Day1.part1(@input) == 11
  end

  test "runs part two on example" do
    assert Day1.part_2(@input) == 31
  end

  test "runs read data" do
    assert Day1.part1() == 2_769_675
  end

  test "runs part two" do
    assert Day1.part_2() == 24_643_097
  end
end
