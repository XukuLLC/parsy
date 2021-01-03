defmodule Parsy.Worker do
    use GenServer
  
    def start_link(_) do
      GenServer.start_link(__MODULE__, nil)
    end
  
    def init(_) do
      {:ok, nil}
    end
  
    def handle_call({:syllabify, chunk_of_words}, from, state) do
      IO.puts("process #{inspect(self())}: hyphenating \"#{inspect(from)}\"")
      {:reply, Parsy.Engine.syllabify(chunk_of_words), state}
    end
  end
