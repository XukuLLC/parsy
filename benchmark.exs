{:ok, contents} = File.read("moby.txt")
# contents = "this is a short but typical string for benchee to benchmark this is a short but typical string for benchee to benchmark this is a short but typical string for benchee to benchmark this is a short but typical string for benchee to benchmark this is a short but typical string for benchee to benchmark this is a short but typical string for benchee to benchmark"

Benchee.run(%{
  "sequential"    => fn -> Parsy.Engine.syllabify(contents) end,
  "concurrent"    => fn -> Parsy.main(contents) end
})