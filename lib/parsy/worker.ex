defmodule Parsy.Worker do
  @moduledoc false
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:syllabify, chunk_of_words}, from, state) do
    Parsy.Logger.log("process #{inspect(self())}: syllabifying \"#{inspect(from)}\"")
    {:reply, Parsy.Engine.syllabify(chunk_of_words), state}
  end
end
