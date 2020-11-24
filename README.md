# About

The `Parsy` module parses and counts syllables, words, complex words, and sentences in the English language. It also calculates the Flesch-Kincaid Readability Score for the given text. The premise is to provide some basic English-language tokenization and metrics without the overhead or complexity of a proper NLP service. 

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

### Using the Module

[View the official documentation on Hex Docs for detailed instructions](https://hexdocs.pm/parsy/0.1.0/parsy.html).

### Using the API

You can receive truncated results (5 of the 8 datapoints) using [the Sprigg API](https://github.com/zuchka/sprigg).

Sprigg maintains a single route: https://api.spri.gg/

To analyze your text, pass it into the body of a POST request.

Here are some example commands:

```bash

curl -X POST -d "analyze this string" https://api.spri.gg

# to read in a local file:

curl -X POST --data-binary "@/path/to/file.md" https://api.spri.gg

# to pass STDIN, like this digital copy of Moby Dick:

curl http://www.gutenberg.org/files/2701/2701-0.txt | curl -X POST -d "@-" https://api.spri.gg
```

A `GET` request to `/` will return these instructions.
