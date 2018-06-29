defmodule EnigmaMachine do
  @moduledoc """
  Documentation for EnigmaMachine.
  """

  import Enum

  @plaintext_size 26
  @plaintext 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  @doc """
  A rotor is returned as a list of outout wires on the right side of the rotor.
  And an offset for the notch (0 based, because: offset, not a position).
  The contacts are represented in a tuple `{left->right, right<-left}`.
  """
  # The list of positions on the left corresponding to the normal ordered alphabet on the right.
  #                                      1    1    2    2
  #                            0    5    0    5    0    5
  #                            ABCDEFGHIJKLMNOPQRSTUVWXYZ
  def rotor(1), do: offsets {'EKMFLGDQVZNTOWYHXUSPAIBRCJ', ?Q}
  def rotor(2), do: offsets  {'AJDKSIRUXBLHWTMCQGZNPYFVOE', ?E}
  def rotor(3), do: offsets  {'BDFHJLCPRTXVZNYEIWGAKMUSQO', ?V}

  #                                         1    1    2    2
  #                               0    5    0    5    0    5
  #                               ABCDEFGHIJKLMNOPQRSTUVWXYZ
  def reflector(:b), do: offsets 'YRUHQSLDPXNGOKMIEBFZCWVJAT'

  def offsets({contacts, notch}),
    do: {offsets(contacts), notch - ?A}

  def offsets(contacts) do
    right_to_left = contacts |> zip(@plaintext) |> map(fn {c, p} -> c - p end)
    left_to_right = contacts |> zip(right_to_left) |> sort |> map(fn {_c, p} -> -p end)
    zip(left_to_right, right_to_left)
  end

  defp mod(i, contacts),
    do: Integer.mod(i, count(contacts))

  defp inc(offset),
    do: (offset + 1) |> mod(@plaintext)

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

  def encode_left_right(input, {contacts, offset}) do
    c = input + offset |> mod(contacts)
    {out, _} = at(contacts, c)
    input + out |> mod(contacts) |> IO.inspect
  end

  def encode_right_left(input, {contacts, offset}) do
    c = input + offset |> mod(contacts)
    {_, out} = at(contacts, c)
    input + out |> mod(contacts) |> IO.inspect
  end

  def encode([input | _text], offsets, [reflector | rotors]) do
    new_offsets = offsets |> rotate(rotors)
    contacts_offsets = rotors
      |> map(fn {c, _n} -> c end)
      |> zip(new_offsets) |> IO.inspect

    signal_path =
      map(contacts_offsets |> reverse,
          fn {c, o} -> &encode_left_right(&1, {c, o}) end)
       ++ [&encode_left_right(&1, {reflector, 0})]
       ++ map(contacts_offsets, fn {c, o} -> &encode_right_left(&1, {c, o}) end)

    [signal_path |> reduce(input - ?A, fn f, i -> f.(i) + ?A end)]
  end

end
