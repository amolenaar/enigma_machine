defmodule EnigmaMachineTest do
  use ExUnit.Case
  doctest EnigmaMachine

  import EnigmaMachine

  defp contacts({contacts, _notch}), do: contacts

  test "rotor redefined" do
    {contacts, notch} = rotor(1)
    # EKMFLGDQVZNTOWYHXUSPAIBRCJ
    assert contacts |> hd == {20, 4}
    assert contacts |> tl |> hd == {21, 9}
    assert notch == 16
  end

  # test "encode a character" do
  #   assert encode_right_left(0, {offsets('BDAC'), 0}) == 1
  #   assert encode_right_left(0, {offsets('BDAC'), 1}) == 2
  #   assert encode_right_left(3, {offsets('BDAC'), 1}) == 0
  #   assert encode_right_left(0, {offsets('BDAC'), 2}) == 2
  #   assert encode_right_left(2, {offsets('BDAC'), 3}) == 0
  #   assert encode_right_left(0, {rotor(1) |> contacts(), 0}) == 4
  #   assert encode_right_left(0, {rotor(1) |> contacts(), 1}) == 9
  #   assert encode_right_left(20, {rotor(1) |> contacts(), 0}) == 0
  # end

  # test "reverse encode a character" do
  #   assert encode_left_right(1, {offsets('BDAC'), 0}) == 0
  #   assert encode_left_right(2, {offsets('BDAC'), 1}) == 0
  #   assert encode_left_right(0, {offsets('BDAC'), 1}) == 3
  #   assert encode_left_right(2, {offsets('BDAC'), 2}) == 0
  #   assert encode_left_right(0, {offsets('BDAC'), 3}) == 2
  #   assert encode_left_right(4, {rotor(1) |> contacts(), 0}) == 0
  #   assert encode_left_right(0, {rotor(1) |> contacts(), 0}) == 20
  # end

  test "rotor rotation" do
    assert rotate([0, 0, 0], [rotor(3), rotor(2), rotor(1)]) == [0, 0, 1]
    assert rotate([3, 0, 1], [rotor(3), rotor(2), rotor(1)]) == [3, 0, 2]
    assert rotate([3, 0, 25], [rotor(3), rotor(2), rotor(1)]) == [3, 0, 0]
  end

  test "rotate when on one notch" do
    # Q has a notch
    assert rotate([0, 0, ?Q - ?A], [rotor(3), rotor(2), rotor(1)]) == [0, 1, ?R - ?A]
  end

  test "rotate when on two notch" do
    # E and Q have notches
    assert rotate([0, ?E - ?A, ?Q - ?A], [rotor(3), rotor(2), rotor(1)]) == [1, ?F - ?A, ?R - ?A]
  end

  test "encode 'H' char step by step" do
    h = ?H - ?A
    assert encode_right_left(h,  {rotor(1) |> contacts(), 1}) == 20
    assert encode_right_left(20, {rotor(2) |> contacts(), 0}) == 15
    assert encode_right_left(15, {rotor(3) |> contacts(), 0}) == 4
    assert encode_right_left(4,  {reflector(:b), 0}) == 16
    assert encode_left_right(16, {rotor(3) |> contacts(), 0}) == 24
    assert encode_left_right(24, {rotor(2) |> contacts(), 0}) == 21
    assert encode_left_right(21, {rotor(1) |> contacts(), 1}) == ?M - ?A
  end

  test "encode one char with default settings" do
    # assert encode('A', [0], [reflector(:b), rotor(1)]) == 'E'
    # assert encode('A', [1], [reflector(:b), rotor(1)]) == 'M'
    assert encode('H', [0,0,0], [reflector(:b), rotor(3), rotor(2), rotor(1)]) == 'M'
    # assert encode('HELLOWORLD', [0,0,0], [reflector(:b), rotor(3), rotor(2), rotor(1)]) == 'MFNCZBBFZM'
    # assert encode('HELLOWORLD', [0,0,0], [ukw(:b), rotor(1), rotor(3), rotor(2)]) == 'ZXVMIZYFEY'
  end


end
