defmodule EnigmaMachineTest do
  use ExUnit.Case
  doctest EnigmaMachine

  test "greets the world" do
    assert EnigmaMachine.hello() == :world
  end
end
