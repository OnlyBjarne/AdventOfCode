defmodule Day5 do
  def go(input) do
    ["seeds: " <> seeds | maps] =
      input
      |> String.split("\n\n", trim: true)

    # seeds = String.split(seeds, " ", trim: true) |> Enum.map(&String.to_integer/1)
    seeds =
      seeds
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, length] ->
        start..(start + (length - 1))
      end)

    maps =
      maps
      |> Enum.reduce([], fn map, acc ->
        [name | lines] = String.split(map, "\n", trim: true)
        name = String.split(name, ":", trim: true) |> List.first()

        new_map =
          lines
          |> Enum.reduce(%{}, fn nums, ac ->
            [dest, source, length] = String.split(nums) |> Enum.map(&String.to_integer/1)
            Map.put(ac, source..(source + (length - 1)), dest - source)
          end)

        # |> Map.put(:__name__, name)

        [new_map | acc]
      end)
      |> Enum.reverse()

    Enum.reduce(maps, seeds, fn map, seeds ->
      seeds
      |> Enum.reduce([], fn range, acc ->
        map
        |> Map.keys()
        |> Enum.reduce({[range], []}, fn s..f = r, {ranges, ac} ->
          Enum.reduce(ranges, {[], ac}, fn start..finish, {untouched, transformed} ->
            diff = Map.get(map, r, :error_invariant)

            cond do
              Range.disjoint?(r, start..finish) ->
                {[start..finish | untouched], transformed}

              # s < start
              s < start and f == start ->
                {[(start + 1)..finish | untouched],
                 [Range.shift(start..start, diff) | transformed]}

              s < start and f < finish ->
                {[(f + 1)..finish | untouched], [Range.shift(start..f, diff) | transformed]}

              s < start and f == finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              s < start and f > finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              # s == start
              s == start and f == start ->
                {[(f + 1)..finish | untouched], [Range.shift(start..f, diff) | transformed]}

              s == start and f < finish ->
                {[(f + 1)..finish | untouched], [Range.shift(start..f, diff) | transformed]}

              s == start and f == finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              s == start and f > finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              # s > start
              s > start and f < finish ->
                {[start..(s - 1), (f + 1)..finish | untouched],
                 [Range.shift(s..f, diff) | transformed]}

              s > start and f == finish ->
                {[start..(s - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}

              s > start and f > finish ->
                {[start..(s - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}

              # s == finish
              s == finish and f == finish ->
                {[start..(finish - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}

              s == finish and f > finish ->
                {[start..(finish - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}
            end
          end)
        end)
        |> then(fn {untouched, transformed} -> untouched ++ transformed ++ acc end)
      end)
    end)
    |> Enum.flat_map(fn s..f -> [s, f] end)
    |> Enum.min()
  end
end

"input.txt" |> File.read!() |> Day5.go() |> IO.inspect()
