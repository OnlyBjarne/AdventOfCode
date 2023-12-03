# 
# --- Day 1: Trebuchet?! ---
#
# Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.
#
# You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.
#
# Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
#
# You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").
#
# As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.
#
# The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.
#
# For example:
#
# 1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet
#
# In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.
#
# Consider your entire calibration document. What is the sum of all of the calibration values?

realdata = File.read!("./input.txt")

testdata = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"

testdata2 = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"

replaceTextNumbers = %{
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}

number_or_string_number = fn x, acc, reverse ->
  if String.contains?(acc, replaceTextNumbers |> Map.keys()) do
    matchedKey =
      Enum.find(Map.keys(replaceTextNumbers), 0, fn key -> String.contains?(acc, key) end)

    {:halt, replaceTextNumbers[matchedKey]}
  else
    case Integer.parse(x) do
      {val, ""} ->
        {:halt, x}

      _ ->
        {:cont,
         if !reverse do
           acc <> x
         else
           x <> acc
         end}
    end
  end
end

rows = String.split(realdata)

first =
  Enum.map(rows, fn x ->
    Enum.reduce_while(String.split(x, ""), "", fn x, acc ->
      number_or_string_number.(x, acc, false)
    end)
  end)

last =
  Enum.map(rows, fn x ->
    Enum.reduce_while(String.split(String.reverse(x), ""), "", fn curr, acc ->
      number_or_string_number.(curr, acc, true)
    end)
  end)

merged =
  Enum.zip_reduce(first, last, [], fn x, y, acc ->
    IO.puts("#{x} #{y}, length: #{length(acc)}")
    [String.to_integer(x <> y) | acc]
  end)

IO.puts("Sum #{Enum.sum(merged)}")
