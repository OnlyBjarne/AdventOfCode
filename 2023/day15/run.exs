test_data = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

defmodule Day15 do
  @input File.read!("./input.txt")

  def parse_input(data) do
    data |> String.split([",", "\n"], trim: true)
  end

  def hash(data) do
    data
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn curr, acc ->
      ascii = :binary.first(curr)
      current_value = acc + ascii
      multiplied = current_value * 17
      rem(multiplied, 256)
    end)
  end

  def add_to_box(data, boxes) do
    [label, f_length] = data |> String.split("=", trim: true)
    hash_key = hash(label)
    box = boxes |> Map.get(hash_key, [])

    index = Enum.find_index(box, fn {l, _} -> l === label end)

    if index !== nil do
      box = List.replace_at(box, index, {label, String.to_integer(f_length)})
      Map.put(boxes, hash_key, box)
    else
      box = box ++ [{label, String.to_integer(f_length)}]
      Map.put(boxes, hash_key, box)
    end
  end

  def remove_from_box(data, boxes) do
    [label] = data |> String.split("-", trim: true)
    hash_key = hash(label)
    box = boxes |> Map.get(hash_key, [])
    box = Enum.filter(box, fn {l, _} -> l !== label end)
    boxes |> Map.put(hash_key, box)
  end

  def p1(data \\ @input) do
    data
    |> parse_input()
    |> Enum.map(fn x -> hash(x) end)
    |> Enum.sum()
  end

  def p2(data \\ @input) do
    data
    |> parse_input()
    |> Enum.reduce(%{}, fn x, boxes ->
      cond do
        String.contains?(x, "=") -> add_to_box(x, boxes)
        String.contains?(x, "-") -> remove_from_box(x, boxes)
        true -> boxes
      end
    end)
    |> Map.to_list()
    |> Enum.map(fn {box, items} ->
      box_number = box

      items
      |> Enum.with_index()
      |> Enum.reduce(0, fn {{label, f_length}, index}, acc ->
        acc + (box_number + 1) * (index + 1) * f_length
      end)
    end)
    |> Enum.sum()
  end
end

# Day15.p1(test_data) |> IO.inspect(label: "Part 1")
Day15.p2() |> IO.inspect(label: "Part 2")
