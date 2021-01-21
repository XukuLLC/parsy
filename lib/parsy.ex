defmodule Parsy do
@moduledoc """
`Parsy` is a fast syllable-parser for English-language strings. It implements a standard algorithm and runs in parallel, making it an efficient and reliable solution for text-processing. `Parsy` accepts a `string` and returns a map with the following values:

- `:syl_count`: an integer. The total number of syllables in `string`
- `:words`: a list of lists. Each word in `string` and its individual `:syl_count`
- `:complex_words`: a list of lists. Each complex word in `string` and its individual `:syl_count`. In English, a complex word is any word with three or more syllables. This value is often used to calculate readability scores.
- `:complex_count`: an integer. The total number of `complex_words` in `string`.
"""
@moduledoc since: "0.1.2"

@doc """

## Usage

Pass a string to `Parsy.main()`:

```
iex> Parsy.main("let's parse some syllables!")

process #PID<0.228.0>: syllabifying "{#PID<0.231.0>, #Reference<0.1896839920.1939079179.3341>}"
```

Every time `Parsy` spawns a new process, it will print an associated PID and reference number to the screen.


Once the computation completes, `Parsy` returns a map:

```
%{
  complex: [["syllables", 3]],
  complex_count: 1,
  syl_count: 6,
  words: [{"lets", 1}, {"parse", 1}, {"some", 1}, {"syllables", 3}]
}
```


"""
@doc since: "0.1.2"

  def main(data) do
    parallel =
    data
    |> Parsy.Syllabify.main()
    
    results =
    Map.new
    |> Map.put(:words, Enum.flat_map(parallel, fn map -> map[:words]    end)
      |> Enum.map(fn [a, _b, _c, d] -> [a, d]                           end))
    |> Map.put(:syl_count, Enum.map(parallel, fn map -> map[:syl_count] end) |> Enum.sum)
    |> Map.put(:text, Enum.map(parallel, fn map -> map[:text]           end)
      |> Enum.join(" "))
    |> Map.put(:complex, Enum.flat_map(parallel, fn map -> map[:words]  end)
      |> Enum.filter(fn [_word, _parsed, _split, count] -> count > 2    end)
      |> Enum.map(fn [word, _parsed, _split, count] -> [word, count]    end))

    results
    |> Map.put(:complex_count, Enum.count(results[:complex]))  
  end
end