defmodule ExMatrixManipulationTest do
  use ExUnit.Case
  import ExMatrix

  test "get_row returns proper row upon request" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    assert [3,4] == get_row(x, 1)
  end

  test "get_row raises ArgumentError if non-matrix is passed" do
    assert_raise ArgumentError, fn ->
      get_row("something", 3) end
  end

  test "get_col returns proper column upon request" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    assert [2,4,6,8] == get_column(x,1)
  end

  test "get_col raises ArgumentError if non-matrix is passed" do
    assert_raise ArgumentError, fn ->
      get_row("something", 3) end
  end

  test "if is_row_vector returns proper result" do
    assert is_row_vector([[1,3,4]])
    assert is_row_vector([[1]])
    refute is_row_vector([1,3,4])
    refute is_row_vector([[1],[3],[4]])
    refute is_row_vector([[1,2],[3,4]])
  end

  test "if is_column_vector returns proper result" do
    assert is_column_vector([[1],[3],[4]])
    assert is_column_vector([[1]])
    refute is_column_vector([[1,3,4]])
    refute is_column_vector([1,3,4])
    refute is_column_vector([[1,2],[3,4]])
  end

  test "size if 2 by 2 matrix passed returns good value" do
    assert {2, 2} == size([[0,0], [0,0]])
  end

  test "transpose if matrix passed returns good matrix" do
    original_matrix = [[6, 7.7],
              [2, 99],
              [14.78964, -55436]]
    transposed_matrix = transpose(original_matrix)
    assert transposed_matrix == [[6, 2, 14.78964],
                                 [7.7, 99, -55436]]
  end
end
