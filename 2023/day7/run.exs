defmodule CamelCards do
  @input File.read!("./input_eirik.txt")

  @high_cards ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
  @high_cards2 ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "1", "J"]

  def parse(data) do
    data
    |> Enum.map(fn x ->
      [cards, score] = String.split(x, " ")
      {cards, String.to_integer(score)}
    end)
  end

  def create_hand_map(hand, joker) do
    current_hand =
      hand
      |> String.graphemes()
      |> Enum.reduce(%{}, fn char, acc ->
        Map.update(acc, char, 1, &(&1 + 1))
      end)

    if(joker) do
      {j_count, new} = Map.pop(current_hand, "J", 0) |> IO.inspect()

      {highest_count, _value} =
        new
        |> Map.to_list()
        |> Enum.max_by(fn {_key, value} -> value end, fn -> {"J", 5} end)

      new |> Map.update(highest_count, j_count, fn value -> value + j_count end)
    else
      current_hand
    end
  end

  def get_hand(card_map) do
    card_values =
      card_map
      |> Map.values()
      |> Enum.sort(fn x, y -> x > y end)

    case card_values do
      [5] -> 1
      [4, 1] -> 2
      [3, 2] -> 3
      [3, 1, 1] -> 4
      [2, 2, 1] -> 5
      [2, 1, 1, 1] -> 6
      [1, 1, 1, 1, 1] -> 7
    end
  end

  def compare_highcards(hand_1, hand_2, compare_list) do
    [card1 | rest1] = hand_1
    [card2 | rest2] = hand_2

    cond do
      card1 == card2 ->
        compare_highcards(rest1, rest2, compare_list)

      true ->
        Enum.find_index(compare_list, fn x -> x == card1 end) <
          Enum.find_index(compare_list, fn x -> x == card2 end)
    end
  end

  def compare_hands({hand_1, _}, {hand_2, _}, joker \\ false) do
    score_1 = get_hand(create_hand_map(hand_1, joker))
    score_2 = get_hand(create_hand_map(hand_2, joker))

    if score_1 == score_2 do
      compare_highcards(
        hand_1 |> String.split(""),
        hand_2 |> String.split(""),
        if joker do
          @high_cards2
        else
          @high_cards
        end
      )
    else
      score_1 < score_2
    end
  end

  def part1(data \\ @input) do
    data
    |> String.split("\n", trim: true)
    |> CamelCards.parse()
    |> Enum.sort(fn hand1, hand2 -> compare_hands(hand2, hand1) end)
    |> Enum.with_index()
    |> Enum.map(fn {{_hand, bet}, index} -> bet * (index + 1) end)
    |> Enum.sum()
  end

  def part2(data \\ @input) do
    data
    |> String.split("\n", trim: true)
    |> CamelCards.parse()
    |> Enum.sort(fn hand1, hand2 -> compare_hands(hand2, hand1, true) end)
    |> IO.inspect()
    |> Enum.with_index()
    |> Enum.map(fn {{_hand, bet}, index} -> bet * (index + 1) end)
    |> Enum.sum()
  end
end

test_data = "32T3K 765
J55J5 684
KK677 28
JJJJJ 220
QQQJA 483"

CamelCards.part1() |> IO.inspect()
# CamelCards.part2() |> IO.inspect()
