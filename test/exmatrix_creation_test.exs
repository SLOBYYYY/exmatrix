defmodule ExMatrixCreationTest do
  use ExUnit.Case
  import ExMatrix

  test "creating a matrix of zeroes" do
    m = zeroes(3, 3)
    assert m == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  test "creating a matrix of ones" do
    m = ones(3, 3)
    assert m == [[1, 1, 1], [1, 1, 1], [1, 1, 1]]
  end

  test "creating a matrix of an arbitrary number" do
    m = new_matrix(9.9, 3, 3)
    assert m == [[9.9, 9.9, 9.9], [9.9, 9.9, 9.9], [9.9, 9.9, 9.9]]
  end

  test "creating a matrix from a list" do
    m = new_matrix([2,4,6,8,10,12], 2, 3)
    assert m == [[2,4,6], [8,10,12]]
  end

  test "if creating a matrix from a list with wrong params throws ArgumentError" do
    assert_raise ArgumentError, fn ->
      new_matrix([2,4,6,8,10,12,666], 2, 3)
    end
  end

  test "create an identity matrix of size 2" do
    i = identity(2)
    assert i == [[1, 0], [0, 1]]
  end

  test "create an identity matrix of size 5" do
    i = identity(5)
    assert i == [
                 [1, 0, 0, 0, 0],
                 [0, 1, 0, 0, 0],
                 [0, 0, 1, 0, 0],
                 [0, 0, 0, 1, 0],
                 [0, 0, 0, 0, 1],
                ]
  end

  test "any matrix multiplied by it's corresponding identity matrix equals itself" do
    a = [[1, 2, 3], [3, 4, 5], [5, 6, 7]]
    i = identity(3)
    assert i == [
                 [1, 0, 0],
                 [0, 1, 0],
                 [0, 0, 1],
                ]
    assert multiply(a, i) == a
  end
end
