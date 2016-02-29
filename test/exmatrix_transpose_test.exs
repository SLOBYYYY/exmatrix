defmodule ExMatrixTransposeTest do
  use ExUnit.Case
  import ExMatrix

  test "transpose a zero matrix" do
    m = new_matrix(3, 2)
    n = transpose(m)
    assert m == [[0, 0],
                 [0, 0],
                 [0, 0]]
    assert n == [[0, 0, 0],
                 [0, 0, 0]]
  end

  test "transpose a regular matrix" do
    original_matrix = [[6, 7.7],
              [2, 99],
              [14.78964, -55436]]
    transposed_matrix = transpose(original_matrix)
    assert transposed_matrix == [[6, 2, 14.78964],
                                 [7.7, 99, -55436]]
  end
end
