defmodule Parsy.Syllabify do
  @moduledoc false
  @timeout 1000000

  def main(data) do
    list =
    String.split(data, ~r/\s|\\n|\\r|\\t|_/, trim: true)
    |> Stream.filter(fn x -> String.valid?(x)end)
    |> Stream.map(fn word -> Regex.replace(~r/'/, word, "") end)
    |> Stream.chunk_every(250)
    |> Enum.map(fn x -> Enum.join(x, " ")end)

    list
    |> Enum.map(fn chunk_of_words -> async_call_syllabify(chunk_of_words) end)
    |> Enum.map(fn task -> await_and_inspect(task) end)
  end

  def async_call_syllabify(chunk_of_words) do
    Task.async(fn ->
      :poolboy.transaction(
        :parsy_worker,
        fn pid -> GenServer.call(pid, {:syllabify, chunk_of_words}, 600000) end,
        @timeout
      )
    end)
  end

  def await_and_inspect(task), do: task |> Task.await(@timeout)
end