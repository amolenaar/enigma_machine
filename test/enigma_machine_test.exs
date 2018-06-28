defmodule EnigmaMachineTest do
  use ExUnit.Case
  doctest EnigmaMachine

  import EnigmaMachine

  test "encode a character" do
    assert encode_char(?A, {'BDAC', 0}) == ?B
    assert encode_char(?A, {'BDAC', 1}) == ?D
    assert encode_char(?D, {'BDAC', 1}) == ?B
    assert encode_char(?C, {'BDAC', 3}) == ?D
  end

  test "reverse encode a character" do
    assert reverse_encode_char(?B, {'BDAC', 0}) == ?A
    assert reverse_encode_char(?D, {'BDAC', 1}) == ?A
    assert reverse_encode_char(?B, {'BDAC', 1}) == ?D
    assert reverse_encode_char(?D, {'BDAC', 3}) == ?C
  end

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

  test "encode wone char with default settings" do
    # assert encode('A', [0], [reflector(:b), rotor(1)]) == 'B'
    # assert encode('A', [1], [reflector(:b), rotor(1)]) == 'M'
    # assert encode('H', [0,0,0], [reflector(:b), rotor(3), rotor(2), rotor(1)]) == 'M'
    assert encode('HELLOWORLD', [0,0,0], [reflector(:b), rotor(3), rotor(2), rotor(1)]) == 'MFNCZBBFZM'
    # assert encode('HELLOWORLD', [0,0,0], [ukw(:b), rotor(1), rotor(3), rotor(2)]) == 'ZXVMIZYFEY'
  end


end
