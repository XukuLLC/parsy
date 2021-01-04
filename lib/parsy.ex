defmodule Parsy do
@moduledoc """

"""
@moduledoc since: "0.1.2"

@doc """



"""
@doc since: "0.1.2"

  def main(data) do
    parallel =
    data
    |> Parsy.Syllabify.main()
    
    results =
    Map.new
    |> Map.put(:words, Enum.flat_map(parallel, fn map -> map[:words]    end)
      |> Enum.map(fn {a, _b, _c, d} -> {a, d}                           end))
    |> Map.put(:syl_count, Enum.map(parallel, fn map -> map[:syl_count] end) |> Enum.sum)
    |> Map.put(:complex, Enum.flat_map(parallel, fn map -> map[:words]  end)
      |> Enum.filter(fn {_word, _parsed, _split, count} -> count > 2    end)
      |> Enum.map(fn {word, _parsed, _split, count} -> [word, count]    end))

    results
    |> Map.put(:complex_count, Enum.count(results[:complex]))  
  end
end