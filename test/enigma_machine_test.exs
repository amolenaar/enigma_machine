defmodule EnigmaMachineTest do
  use ExUnit.Case
  doctest EnigmaMachine

  import EnigmaMachine

  test "encode a character" do
    assert EnigmaMachine.encode_char(?A, {'BDAC', 0}) == ?B
    assert EnigmaMachine.encode_char(?A, {'BDAC', 1}) == ?D
    assert EnigmaMachine.encode_char(?D, {'BDAC', 1}) == ?B
    assert EnigmaMachine.encode_char(?C, {'BDAC', 3}) == ?D
  end

  test "reverse rotor" do
    assert EnigmaMachine.reverse_rotor('BDAC') == 'CADB'
  end

  test "rotor rotation" do
    rotate([0, 0, 0], [rotor(3), rotor(2), rotor(1)]) == [0, 0, 1]
  end

  test "encode wone char with default settings" do
    # assert EnigmaMachine.encode('A', {0}, [@rotor_1], @ukw_b) == 'H'
    # assert EnigmaMachine.encode('H', {0}, [@rotor_1], @ukw_b) == 'A'
    # assert EnigmaMachine.encode('A', {0,0}, [@rotor_2, @rotor_1], @ukw_b) == 'N'
    # assert EnigmaMachine.encode('H', {0,0}, [@rotor_2, @rotor_1], @ukw_b) == 'J'
    # assert encode('HELLOWORLD', [0,0,0], [ukw(:b), rotor(3), rotor(2), rotor(1)]) == 'MFNCZBBFZM'
    # assert encode('HELLOWORLD', [0,0,0], [ukw(:b), rotor(1), rotor(3), rotor(2)]) == 'ZXVMIZYFEY'
  end

  test "encode with default settings" do
    # assert EnigmaMachine.encode('HELLOWORLD') == 'MFNCZBBFZM'
  end


end
