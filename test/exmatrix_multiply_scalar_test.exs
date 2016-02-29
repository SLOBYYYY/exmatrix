defmodule ExMatrixMultiplyScalarTest do
  use ExUnit.Case
  import ExMatrix

  test "simple scalar multiplication" do
    matrix = [[1, 2], 
              [3, 4],
              [15, 16]]
    scalar_matrix = multiply_scalar(matrix, 3)
    assert scalar_matrix == [[3, 6],
                             [9, 12],
                             [45, 48]]
  end

  test "scalar multiplication with float scalar" do
    matrix = [[1, 2], 
              [3, 4],
              [15, 16]]
    scalar_matrix = multiply_scalar(matrix, 1.5)
    assert scalar_matrix == [[1.5, 3],
                             [4.5, 6],
                             [22.5, 24]]
  end

  test "scalar multiplication with float matrix" do
    matrix = [[1.1, 2.2], 
              [3.3, 4.4],
              [15.15, 16.16]]
    scalar_matrix = multiply_scalar(matrix, 2)
    assert scalar_matrix == [[2.2, 4.4],
                             [6.6, 8.8],
                             [30.3, 32.32]]
  end

  test "scalar multiplication with float matrix and float scalar" do
    matrix = [[1.1, 2.2], 
              [3.3, 4.4],
              [15.15, 16.16]]
    scalar_matrix = multiply_scalar(matrix, 2.2)
    assert scalar_matrix == [[2.42, 4.84],
                             [7.26, 9.68],
                             [33.33, 35.552]]
  end
end
