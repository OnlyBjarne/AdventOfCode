defmodule Day3Test do
  use ExUnit.Case

  @input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  test "runs part 1 on example" do
    assert Day4.part_1(@input) == 18
  end

  test "runs part two on example" do
    assert Day4.part_2(@input2) == 48
  end

  test "runs part 1" do
    assert Day4.part_1() == 175_700_056
  end

  #
  test "runs part two" do
    assert Day4.part_2() == 71_668_682
  end
end
