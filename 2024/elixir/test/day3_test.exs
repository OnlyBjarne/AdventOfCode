defmodule Day3Test do
  use ExUnit.Case

  @input """
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

  # 0-19 and 58 -> end 
  @input2 "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  test "runs part 1 on example" do
    assert Day3.part_1(@input) == 161
  end

  test "runs part two on example" do
    assert Day3.part_2(@input2) == 48
  end

  test "runs part 1" do
    assert Day3.part_1() == 175_700_056
  end

  #
  test "runs part two" do
    assert Day3.part_2() == 71_668_682
  end
end
