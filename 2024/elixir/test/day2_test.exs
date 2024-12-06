defmodule Day1Test do
  use ExUnit.Case

  @input """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  test "runs on example" do
    assert Day2.part_1(@input) == 2
  end

  test "runs part two on example" do
    assert Day2.part_2(@input) == 4
  end

  test "runs read data" do
    assert Day2.part_1() == 252
  end

  #
  test "runs part two" do
    assert Day2.part_2() |> IO.inspect() > 302
  end
end
