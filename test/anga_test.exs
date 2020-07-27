defmodule AngaTest do
  use ExUnit.Case
  doctest Anga

  test "greets the world" do
    assert Anga.hello() == :world
  end
end
