defmodule Parsy.Engine do
@moduledoc false
    # We need to return the parsed word and the parsed word filtered through the syllabifier logic: {"Here", "her"}
    def parse_words(data) do
        Map.put(data, :words, Enum.zip(String.split(data[:text], ~r{\w+}, trim: true, include_captures: true)
        |> Enum.filter(fn word -> Regex.match?(~r/[a-zA-Z]/, word)end)
        |> Enum.map(fn word -> String.downcase(word)end)
        |> Enum.map(fn word -> String.replace_trailing(word, "e", "") end)
        |> Enum.map(fn word -> Regex.replace(~r/(?<=\w)'(?=\w)/, word, "") end),
        String.split(data[:text], ~r{\w+}, trim: true, include_captures: true)
        |> Enum.filter(fn word -> Regex.match?(~r/[a-zA-Z]/, word)end)))
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
        Regex.match?(regex, hit) end) end)) |> Enum.sum
        } end))
    end

    # adds syllable count for scenarios like "x", "the" (becomes "th" when parsed), and "crwth"
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
  
    def word_count(data) do
        Map.put(data, :word_count, Enum.count(data[:words]))
    end
  
    def sent_count(data) do
        Map.put(data, :sent_count, String.split(data[:text], ~r{\.}, trim: true)
        |> Enum.count())
    end
    
    # In English, a complex word is any word with three or more syllables
    def complex(data) do
        Map.put(data, :complex, Enum.filter(data[:words], fn {_word, _parsed, _split, count} -> count > 2 end)
        |> Enum.map(fn {word, _parsed, _split, count} -> [word, count] end))
    end
  
    def complex_count(data) do
        Map.put(data, :complex_count, Enum.count(data[:complex]))
    end
    
    def flesch_kincaid(data) do
        Map.put(data, :flesch_kincaid, 206.835 - (1.015 * (data[:word_count]/data[:sent_count])) - (84.6 * (data[:syl_count]/data[:word_count])))
    end
  end