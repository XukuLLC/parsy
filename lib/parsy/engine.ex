defmodule Parsy.Engine do
@moduledoc false
  # We need to return the parsed word and the parsed word filtered through the syllabifier logic: {"Here", "her"}
  def syllabify(chunk_of_words) do
    parsy =
    Map.new
    |> Map.put(:text, chunk_of_words)

    parsy
    |> Parsy.Engine.parse_words()
    |> Parsy.Engine.parse_syls()
    |> Parsy.Engine.syl_count()
  end

  def parse_words(data) do
    Map.put(data, :words, Enum.zip(String.split(data[:text], ~r{\w+}, trim: true, include_captures: true)
    |> Enum.filter(fn word -> Regex.match?(~r/[a-zA-Z]/, word)end)
    |> Enum.map(fn word -> String.downcase(word)end)
    |> Enum.map(fn word -> String.replace_trailing(word, "e", "") end),
    String.split(data[:text], ~r{\w+}, trim: true, include_captures: true)
    |> Enum.filter(fn word -> Regex.match?(~r/[a-zA-Z]/, word)end))
    )
  end

  def parse_syls(data) do
    Map.put(data, :words, Enum.map(data[:words], fn {parsed, word} ->
    {word, parsed, String.split(parsed, ~r{[^aeiouy]+}, trim: true, include_captures: true)} end) )
  end

  def syl_count(data) do
    data
    |> first_pass()
    |> second_pass()
    |> third_pass()
    |> fourth_pass()
    |> syl_total
  end

  # the first pass is a rough pass. It counts all the vowels in `parsed`
  def first_pass(data) do
    Map.put(data, :words, Enum.map(data[:words], fn {word, parsed, split} ->
    {word, parsed, split, Enum.count(split, fn hit -> Regex.match?(~r{[aeiouy]+}, hit)end)} end))
  end

  # the next three passes massage the list with common exeptions and rules
  def second_pass(data) do
    add_list = [~r/ia/, ~r/riet/, ~r/dien/, ~r/iu/, ~r/io/, ~r/ii/, ~r/[aeiouym]bl$/, ~r/[aeiou]{3}/, ~r/^mc/, ~r/ism$/, ~r/([^aeiouy])\1l$/, ~r/[^l]lien/, ~r/^coa[dglx]./, ~r/[^gq]ua[^auieo]/, ~r/dnt$/, ~r/ea$/]
    Map.put(data, :words,
    Enum.map(data[:words], fn {word, parsed, split, count}   ->
    {word, parsed, split, count + (Enum.map([parsed], fn hit ->
    Enum.count(add_list, fn regex                            ->
    Regex.match?(regex, hit) end) end) |> Enum.sum)
    } end))
  end

  def third_pass(data) do
    subtract_list = [~r/cial/, ~r/tia/, ~r/cius/, ~r/cious/, ~r/giu/, ~r/ion/, ~r/sia$/, ~r/.ely$/]
    Map.put(data, :words, 
    Enum.map(data[:words], fn {word, parsed, split, count}  ->
    {word, parsed, split, (Enum.map([word], fn hit          -> 
    count - Enum.count(subtract_list, fn regex              -> 
    Regex.match?(regex, hit) end) end) |> Enum.sum)
    } end))
  end

  # adds syllable count for zero-word scenarios like "x", "the" (becomes "th" when parsed), and "crwth"
  def fourth_pass(data) do
    Map.put(data, :words,
    Enum.map(data[:words], fn {word, parsed, split, count}  ->
    {word, parsed, split, count + zero_match(count)} end))
  end

  def zero_match(0) do
    1
  end

  def zero_match(_x) do
    0
  end

  def syl_total(data) do
    Map.put(data, :syl_count, Enum.map(data[:words], fn {_word, _parsed, _split, count} -> count end) |> Enum.sum())
  end
end