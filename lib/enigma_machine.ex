defmodule EnigmaMachine do
  @moduledoc """
  Documentation for EnigmaMachine.
  """

  import Enum

  @alphabet 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  def rotor(1), do: {'EKMFLGDQVZNTOWYHXUSPAIBRCJ', ?Q}
  def rotor(2), do: {'AJDKSIRUXBLHWTMCQGZNPYFVOE', ?E}
  def rotor(3), do: {'BDFHJLCPRTXVZNYEIWGAKMUSQO', ?V}

  def ukw(:b), do: 'YRUHQSLDPXNGOKMIEBFZCWVJAT'


  def encode_char(input, {rotor, offset}) do
    Enum.at(rotor, input - ?A + offset |> Integer.mod(Enum.count(rotor)))
  end

  def reverse_rotor(rotor) do
    Enum.zip(rotor, @alphabet)
    |> Enum.sort
    |> Enum.map(fn {_a, b} -> b end) |> IO.inspect
  end

  def reverse_encode(input, {rotor, _notch}, offset) do
    Enum.at(rotor, input - ?A + offset |> Integer.mod(Enum.count(rotor)))
  end

  def encode([input | _text], offsets, [ukw | rotors]) do
    rotor_offsets = zip(rotors, offsets)
    all_rotors = map(rotor_offsets |> reverse, fn {{r, _n}, o} -> {reverse_rotor(r), o} end) ++ [{ukw, 0}] ++ map(rotor_offsets, fn {{r, _n}, o} -> {r, o} end)

    [all_rotors |> reduce(input, &(encode_char(&2, &1)))]
  end

end
