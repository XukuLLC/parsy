defmodule Parsy do
  @moduledoc """
The `Parsy` module parses and counts syllables, words, complex words, and sentences in the English language. It also calculates the Flesch-Kincaid Readability Score for the given text. The premise is to provide some basic English-language tokenization and metrics without the overhead of a proper NLP service. 

`Parsy` has one entrypoint: `Parsy.main/1`.
"""
@moduledoc since: "0.1.0"

@doc """

Analyzes `:text` in the given map `data` and returns eight values: syllable count, word count, sentence count, complex-word count, a list of complex words and their syllables, a list of words and their syllables, the Flesch-Kincaid Readability Score, and the original text.

`main` accepts one parameter, `data`, a map that must include the key `:text` and the associated value `"string"`.

`main` will then analyze `"string"` and return seven new key/value pairs: `:complex`, `:complex_count`, `:flesch_kincaid`, `:sent_count`, `:syl_count`, `:word_count`, and `:words`.

Here is an overview of the types and values that `main` returns:

- `:complex` : A list of lists: every complex word and its syllable count. A complex word in English is any word with three or more syllables.
- `:complex_count` : the total number of complex words
- `:flesch_kincaid` : the Flesch-Kincaid readability score. This is a widely used metric for gauging the difficulty of an English-language text.
- `:sent_count` : the total number of sentences
- `:syl_count` : the total number of syllables
- `:text` : the original string
- `:word_count` : the total number of words
- `:words` : A list of four-element tuples: `{"word1", "word1-parsed", "word1-syllabified", word1-syl-count}`

**A Note on the Flesch-Kincaid Readability Score:** The score has an upper boundary of `121.22`. The higher the score, the more readable the text. Scores from `100.0-90.0` are very easy to read. `70.0-60.0` is the "plain english" sweet spot. Scores from `10.0-0` are extremely difficult to read and often professional scholarship. Technically, the scale has no lower boundary. The string `"inspecting multitudes of unadulterated ungulates"` returns a valid score of `-102.79`.

A Flesch-Kincaid Score of `60` or higher is an ideal goal for general web content.

**A Note on large files:** When parsing large amounts of text, the values for `:complex`, `:words`, and `:text` can become large and cumbersome. When testing large datasets, it can be useful to drop these three key/value pairs. Piping your results into `Map.drop([:text, :words, :complex])` works well.

## Examples

    iex> Parsy.main(%{text: "the cat sat on the mat. drat"})
    %{
      complex: [],
      complex_count: 0,
      flesch_kincaid: 118.6825,
      sent_count: 2,
      syl_count: 7,
      text: "the cat sat on the mat. drat",
      word_count: 7,
      words: [
        {"the", "th", ["th"], 1},
        {"cat", "cat", ["c", "a", "t"], 1},
        {"sat", "sat", ["s", "a", "t"], 1},
        {"on", "on", ["o", "n"], 1},
        {"the", "th", ["th"], 1},
        {"mat", "mat", ["m", "a", "t"], 1},
        {"drat", "drat", ["dr", "a", "t"], 1}
      ]
    }

    iex> data = %{text: "inspecting multitudes of unadulterated ungulates"}
    %{
      text: "inspecting multitudes of unadulterated ungulates"
    }

    iex> Parsy.main(data)
    %{
      complex: [
        ["inspecting", 3],
        ["multitudes", 4],
        ["unadulterated", 6],
        ["ungulates", 4]
      ],
      complex_count: 4,
      flesch_kincaid: -102.79999999999998,
      sent_count: 1,
      syl_count: 18,
      text: "inspecting multitudes of unadulterated ungulates",
      word_count: 5,
      words: [
        {"inspecting", "inspecting", ["i", "nsp", "e", "ct", "i", "ng"], 3},
        {"multitudes", "multitudes", ["m", "u", "lt", "i", "t", "u", "d", "e", "s"],
        4},
        {"of", "of", ["o", "f"], 1},
        {"unadulterated", "unadulterated",
        ["u", "n", "a", "d", "u", "lt", "e", "r", "a", "t", "e", "d"], 6},
        {"ungulates", "ungulates", ["u", "ng", "u", "l", "a", "t", "e", "s"], 4}
      ]
    }

    iex> Parsy.main(data) |> Map.drop([:complex, :text, :words])
    %{
      complex_count: 4,
      flesch_kincaid: -102.79999999999998,
      sent_count: 1,
      syl_count: 18,
      word_count: 5
    }

"""
@doc since: "0.1.0"

alias Parsy.Engine

  def main(data) do
    # parallel =
    data
    |> Parsy.Syllabify.main()
    # |> IO.puts()

    # sequential =
    # data
    # |> Engine.word_count()
    # |> Engine.sent_count()
    # |> Engine.complex()
    # |> Engine.complex_count()
    # |> Engine.flesch_kincaid()
    # |> IO.puts()
  end
end