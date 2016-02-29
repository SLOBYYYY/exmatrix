defmodule ExMatrixSequentialMultiplicationTest do
  use ExUnit.Case
  import ExMatrix

  test "creating a matrix" do
    m = new_matrix(3, 3)
    assert m == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  test "if non-matrix input passed, ArgumentError is raised" do
    assert_raise ArgumentError, fn ->
      multiply("banana", 99.99) end
  end

  test "if list input passed with inappropriate elements, ArgumentError is raised" do
    assert_raise ArgumentError, fn ->
      multiply([1,3, "potato"], [4,5,nil]) end
  end

  test "if jagged 'matrix' is passed, ArgumentError is raised" do
    assert_raise ArgumentError, fn ->
      multiply([[1,3], [4,55], [88,55,7]], [4,5,3]) end
  end

  test "row vector multiplied by column vector returns scalar" do
    row_vector = [[4,5,6]]
    column_vector = [[2],[3],[4]]
    result = multiply(row_vector, column_vector)
    assert result == 4*2 + 5*3 + 6*4
  end

  test "column vector multiplied by row vector returns scalar" do
    column_vector = [[2],[3],[4]]
    row_vector = [[4,5,6]]
    result = multiply(column_vector, row_vector)
    assert result == [[8, 10, 12],
                      [12, 15, 18],
                      [16, 20, 24]]
  end

  test "square matrix multiplied with column vector returns square matrix" do
    square_matrix = [[2,3], [3,5]]
    column_vector = [[4], [9]]
    result = multiply(square_matrix, column_vector)
    assert result == [[35], [57]]
  end

  test "square matrices multiplied produce square matrix" do
    x = [[2,3], [3,5]]
    y = [[1,2], [5,-1]]
    z = multiply(x, y)
    assert z == [[17, 1], [28, 1]]
  end

  test "if different sized matrices yield proper sized matrix" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    y = [[12,13,14],
         [15,16,17]] # 2x3
    result = multiply(x, y)
    assert {4,3} == size(result)
  end

  test "if different sized matrices that do not fit raise exception" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    y = [[12,13,14]] # 1x3
    # 1st matrix's column count has to be equal to 2nd matrix's row count
    assert_raise ArgumentError, fn ->
      multiply(x,y) end
  end

  test "large matrix sequentially" do
    random_a = random_cells(50, 50, 100)
    random_b = random_cells(50, 50, 100)
    result = multiply(random_a, random_b)
    assert length(result) == 50
  end

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
end
