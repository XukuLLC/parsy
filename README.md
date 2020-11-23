# About

The `Parsy` module parses and counts syllables, words, complex words, and sentences in the English language. It also calculates the Flesch-Kincaid Readability Score for the given text. The premise is to provide some basic English-language tokenization and metrics without the overhead or complexity of a proper NLP service. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), add `parsy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:parsy, "~> 0.0.1"}
  ]
end
```

<!-- ## How To Use the Syllabify Module

You can call the `main` function or you can call the API.

To call the module directly, use the entrypoint `Parsy.main/1`. This will return a map with eight key/value pairs.

See the module documentation for usage details.

To call the module via the API, send your text in the body of POST request to `https://api.spri.gg`. This will return a map with identical values to `Parsy.main/1` but in JSON format.

**Note:** Passing a large text to the API can result in a large and cumbersome output. To drop the three largest values&mdash;`text`, `words`, and `complex`&mdash;before returning your JSON, use the `https://api.spri.gg/counts` route instead.

For example, here we are downloading the unabridge copy of Moby Dick from Project Gutenberg and passing it to `api.spri.gg/counts`:

```bash
curl moby dick here to 
```

If we hadn't, `STDOUT` would have become glutted with the larger values.

Redirecting your results to a file is another quick solution:

```bash
curl moby dick to spri.gg to file
``` -->
