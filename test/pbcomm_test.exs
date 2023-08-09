defmodule PbcommTest do
  use ExUnit.Case
  doctest Pbcomm

  test "greets the world" do
    assert Pbcomm.hello() == :world
  end
end
