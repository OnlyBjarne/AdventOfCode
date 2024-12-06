defmodule Day19 do
  @input File.read!("./input.txt")

  def parse_input(data) do
    [workflows, inputs | _] = data |> String.split("\n\n", trim: true)

    workflows =
      workflows
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{"A" => [["A"]], "R" => [["R"]]}, fn current, acc ->
        [_, name, rest] =
          Regex.run(~r/(.*)\{(.*)\}/, current) |> List.flatten()

        checks =
          String.split(rest, ",", trim: true)
          |> Enum.map(fn check ->
            check
            |> String.replace(">", " > ")
            |> String.replace("<", " < ")
            |> String.split([":", " "], trim: true)
          end)
          |> Enum.map(fn value ->
            case value do
              [target] -> [target]
              [key, operand, value, target] -> [key, operand, String.to_integer(value), target]
            end
          end)

        Map.put(acc, name, checks)
      end)

    inputs =
      inputs
      |> String.split("\n", trim: true)
      |> Enum.map(fn item ->
        item
        |> String.slice(1..-2)
        |> String.split([",", "="])
        |> Enum.chunk_every(2)
        |> Map.new(fn [key, value] -> {key, String.to_integer(value)} end)
      end)

    [workflows, inputs]
  end

  def calculate_value(data, current_workflow, workflows) do
    workflows[current_workflow]
    |> Enum.find_value(0, fn x ->
      case x do
        ["R"] ->
          0

        ["A"] ->
          Map.values(data) |> Enum.sum()

        [target] ->
          calculate_value(data, target, workflows)

        [key, ">", value, target] ->
          if(Map.get(data, key) > value) do
            case target do
              "A" ->
                Map.values(data) |> Enum.sum()

              "R" ->
                0

              _ ->
                calculate_value(data, target, workflows)
            end
          end

        [key, "<", value, target] ->
          if(Map.get(data, key) < value) do
            case target do
              "A" ->
                Map.values(data) |> Enum.sum()

              "R" ->
                0

              t ->
                calculate_value(data, t, workflows)
            end
          end

        _ ->
          0
      end
    end)
  end

  def calculate_value_range(data, current_workflow, workflows, acc) do
    current_step =
      hd(current_workflow)

    case current_step do
      ["A"] ->
        [data | acc]

      ["R"] ->
        acc

      [next] ->
        acc = calculate_value_range(data, workflows[next], workflows, acc)

      [key, op, value, target] ->
        current_range = data[key]

        [start] = Enum.take(current_range, 1)

        # split at value - start to handle offset

        case op do
          "<" ->
            {left, right} =
              Range.split(current_range, value - start)

            acc =
              calculate_value_range(Map.put(data, key, left), workflows[target], workflows, acc)

            acc =
              calculate_value_range(
                Map.put(data, key, right),
                tl(current_workflow),
                workflows,
                acc
              )

            acc

          ">" ->
            {left, right} =
              Range.split(current_range, value - start + 1)

            acc =
              calculate_value_range(Map.put(data, key, right), workflows[target], workflows, acc)

            acc =
              calculate_value_range(
                Map.put(data, key, left),
                tl(current_workflow),
                workflows,
                acc
              )

            acc
        end
    end
  end

  def p1(data \\ @input) do
    [workflows, inputs] = data |> parse_input()

    inputs
    |> Enum.map(fn x -> calculate_value(x, "in", workflows) end)
    |> Enum.sum()
  end

  def p2(data \\ @input) do
    [workflows, _] = data |> parse_input()

    start = %{"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}

    calculate_value_range(start, workflows["in"], workflows, [])
    |> Enum.map(fn map ->
      map
      |> Map.values()
      |> Enum.map(fn range ->
        range
        |> Range.size()
      end)
      |> Enum.product()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

test_input = "
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}"

# Day19.p1(test_input)
# |> IO.inspect(label: "Part 1")
# |> (&IO.inspect(&1 < 550_017, label: "Less than highest")).()

test_input2 = "
in{x>1:R,m>1:R,a>1:R,s>1:R,A}

{x=1,m=1,a=1,s=1}"

Day19.p2()
|> IO.inspect(label: "part 2")
