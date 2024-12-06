defmodule Common do
  def read_file(filename) do
    File.read!(filename)
  end

  def to_lines(input) do
    input
    |> String.split("\n", trim: true)
  end
end
