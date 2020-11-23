defmodule ParsyTest do
  use ExUnit.Case
  doctest Parsy

  test "greets the world" do
    assert Parsy.hello() == :world
  end
end
