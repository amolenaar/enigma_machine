defmodule EnigmaMachine do
  @moduledoc """
  Documentation for EnigmaMachine.
  """

  import Enum

  @alphabet_size 26
  @alphabet              'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  @doc """
  A rotor is returned as a list of outout wires on the right side of the rotor.
  And an offset for the notch (0 based, because: offset, not a position).
  """
  def rotor(1), do:     {'EKMFLGDQVZNTOWYHXUSPAIBRCJ', ?Q - ?A}
  def rotor(2), do:     {'AJDKSIRUXBLHWTMCQGZNPYFVOE', ?E - ?A}
  def rotor(3), do:     {'BDFHJLCPRTXVZNYEIWGAKMUSQO', ?V - ?A}

  def reflector(:b), do: 'YRUHQSLDPXNGOKMIEBFZCWVJAT'

  defp inc(offset),
    do: (offset + 1) |> Integer.mod(@alphabet_size)

  defp do_rotate([{notch, offset} | t], acc) when notch == offset,
    do: do_rotate(t, [inc(offset) | acc])

  defp do_rotate([{_notch, offset} | t], acc),
    do: no_rotate(t, [inc(offset) | acc])

  defp do_rotate([], acc),
    do: acc

  defp no_rotate([{_notch, offset} | t], acc),
    do: no_rotate(t, [offset | acc])

  defp no_rotate([], acc),
    do: acc

  def rotate(offsets, rotors) do
    rotors
    |> map(fn {_c, n} -> n end)
    |> zip(offsets)
    |> reverse()
    |> do_rotate([])
  end

  def encode_char(input, {contacts, offset}) do
    Enum.at(contacts, input - ?A + offset
    |> Integer.mod(Enum.count(contacts))) |> IO.inspect
  end

  def reverse_encode_char(input, {contacts, offset}) do
    (find_index(contacts, fn p -> p == input end) - offset
    |> Integer.mod(Enum.count(contacts))) + ?A |> IO.inspect
  end

  def encode([input | _text], offsets, [reflector | rotors]) do
    new_offsets = offsets |> rotate(rotors)
    contacts_offsets = rotors
      |> map(fn {c, _n} -> c end)
      |> zip(new_offsets) |> IO.inspect

    signal_path =
      map(contacts_offsets |> reverse,
          fn {c, o} -> &reverse_encode_char(&1, {c, o}) end)
       ++ [&encode_char(&1, {reflector, 0})]
       ++ map(contacts_offsets, fn {c, o} -> &encode_char(&1, {c, o}) end)

    [signal_path |> reduce(input, fn f, i -> f.(i) end)]
  end

end
