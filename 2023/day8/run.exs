# --- Day 8: Haunted Wasteland ---
#
# You're still riding a camel across Desert Island when you spot a sandstorm quickly approaching. When you turn to warn the Elf, she disappears before your eyes! To be fair, she had just finished warning you about ghosts a few minutes ago.
#
# One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of left/right instructions, and the rest of the documents seem to describe some kind of network of labeled nodes.
#
# It seems like you're meant to use the left/right instructions to navigate the network. Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!
#
# After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel like AAA is where you are now, and you have to follow the left/right instructions until you reach ZZZ.
#
# This format defines each node of the network individually. For example:
#
# test_data = "RL
#
# AAA = (BBB, CCC)
# BBB = (DDD, EEE)
# CCC = (ZZZ, GGG)
# DDD = (DDD, DDD)
# EEE = (EEE, EEE)
# GGG = (GGG, GGG)
# ZZZ = (ZZZ, ZZZ)"
#
# test_data2 = "LLR
#
# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)"
#
# test_data3 = "LR
#
# 11A = (11B, XXX)
# 11B = (XXX, 11Z)
# 11Z = (11B, XXX)
# 22A = (22B, XXX)
# 22B = (22C, 22C)
# 22C = (22Z, 22Z)
# 22Z = (22B, 22B)
# XXX = (XXX, XXX)"
#
# Starting with AAA, you need to look up the next element based on the next left/right instruction in your input. In this example, start with AAA and go right (R) by choosing the right element of AAA, CCC. Then, L means to choose the left element of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.
#
# Of course, you might not find ZZZ right away. If you run out of left/right instructions, repeat the whole sequence of instructions as necessary: RL really means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that takes 6 steps to reach ZZZ:
#
# LLR
#
# AAA = (BBB, BBB)
# BBB = (AAA, ZZZ)
# ZZZ = (ZZZ, ZZZ)
#
# Starting at AAA, follow the left/right instructions. How many steps are required to reach ZZZ?
defmodule HauntedWasteland do
  @input File.read!("./input.txt")

  def parse_input(data) do
    [directions, table] = data |> String.split("\n\n")

    table =
      table
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn string, acc ->
        [key, l, r] = Regex.scan(~r/\w+/, string) |> List.flatten()
        Map.put(acc, key, [l, r])
      end)

    directions = directions |> String.split("", trim: true)

    {directions, table}
  end

  def walk(instructions, current_key, table, index, target \\ "ZZZ") do
    instruction =
      instructions
      |> hd()

    new_key =
      case instruction do
        "L" -> Map.get(table, current_key) |> List.first()
        "R" -> Map.get(table, current_key) |> List.last()
      end

    if new_key |> String.ends_with?(target) do
      {index + 1, new_key}
    else
      walk(tl(instructions) ++ [instruction], new_key, table, index + 1, target)
    end
  end

  def part1(data \\ @input) do
    {instructions, table} = parse_input(data)

    walk(instructions, "AAA", table, 0)
  end

  def part2(data \\ @input, start_keys \\ ["QKA", "AAA", "VMA", "RKA", "LBA", "JMA"]) do
    {instructions, table} = parse_input(data)

    Enum.map(start_keys |> Enum.with_index(), fn {key, _index} ->
      walk(instructions, key, table, 0, "Z")
    end)
    |> IO.inspect()
  end

  def walk_multiple(instructions, current_keys, table, index) do
    if Enum.count(current_keys, &String.ends_with?(&1, "Z")) >= 1 do
      IO.puts("#{index} steps, #{current_keys}")
    end

    if Enum.all?(current_keys, fn key -> String.ends_with?(key, "Z") end) do
      index
    else
      instruction =
        instructions
        |> hd()

      new_keys =
        Enum.map(current_keys, fn current_key ->
          case instruction do
            "L" -> Map.get(table, current_key) |> List.first()
            "R" -> Map.get(table, current_key) |> List.last()
          end
        end)

      walk_multiple(tl(instructions) ++ [instruction], new_keys, table, index + 1)
    end
  end
end

# HauntedWasteland.part1() |> IO.inspect()
:timer.tc(fn ->
  HauntedWasteland.part2()
end)
|> elem(0)
|> Kernel./(1_000)
|> IO.inspect()
