# About

`Parsy` is a fast syllable-parser for English-language strings. It implements a standard algorithm and runs in parallel, making it an efficient and reliable solution for text-processing. `Parsy` accepts a `string` and returns a map with the following values:

- `:syl_count`: an integer. The total number of syllables in `string`
- `:words`: a list of tuples. Each word in `string` and its individual `:syl_count`
- `:complex_words`: a list of lists. Each complex word in `string` and its individual `:syl_count`. In English, a complex word is any word with three or more syllables. This value is often used to calculate readability scores.
- `:complex_count`: an integer. The total number of `complex_words` in `string`.

## Installation

If [available in Hex](https://hex.pm/docs/publish), add `parsy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:parsy, "~> 0.1.0"}
  ]
end
```

## Usage

Pass a string to `Parsy.main()`. Here is an example:

```
iex> Parsy.main("let's parse some syllables!")

process #PID<0.228.0>: syllabifying "{#PID<0.231.0>, #Reference<0.1896839920.1939079179.3341>}"
```

Every time `Parsy` spawns a new process, it will print the associated PID and reference number to the screen.


Once the computation completes, `Parsy` returns a map:

```
%{
  complex: [["syllables", 3]],
  complex_count: 1,
  syl_count: 6,
  words: [{"lets", 1}, {"parse", 1}, {"some", 1}, {"syllables", 3}]
}
```
