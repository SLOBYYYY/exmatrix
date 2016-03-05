defmodule ExMatrixOperationsTest do
  use ExUnit.Case
  import ExMatrix

  test "add of valid size matrices returns proper matrix" do
    assert add([[0, 1, 2], [9, 8, 7]], [[6, 5, 4], [3, 4, 5]]) ==
      [[6, 6, 6], [12, 12, 12]]
  end

  test "add of mis-matched matrices raises ArgumentError" do
    assert_raise ArgumentError, fn ->
      add([[0]], [[1,1]])
    end
  end

  test "subtract of valid size matrices returns proper matrix" do
    assert subtract([[0, 1, 2], [9, 8, 7]], [[6, 5, 4], [3, 4, 5]]) ==
      [[-6, -4, -2], [6, 4, 2]]
  end

  test "subtraction of mis-matched matrices raises ArgumentError" do
    assert_raise ArgumentError, fn ->
      subtract([[0]], [[1,1]])
    end
  end

  test "multiply if non-matrix input passed, ArgumentError is raised" do
    assert_raise ArgumentError, fn ->
      multiply("banana", 99.99) end
  end

  test "multiply list input passed with inappropriate elements, ArgumentError is raised" do
    assert_raise ArgumentError, fn ->
      multiply([1,3, "potato"], [4,5,nil]) end
  end

  test "multiply if jagged 'matrix' is passed, ArgumentError is raised" do
    assert_raise ArgumentError, fn ->
      multiply([[1,3], [4,55], [88,55,7]], [4,5,3]) end
  end

  test "multiply if row vector is multiplied by column vector raises ArgumentError" do
    row_vector = [[4,5,6]]
    column_vector = [[2],[3],[4]]
    assert_raise ArgumentError, fn ->
      multiply(row_vector, column_vector) end
  end

  test "multiply if column vector multiplied by row vector raises ArgumentError" do
    column_vector = [[2],[3],[4]]
    row_vector = [[4,5,6]]
    assert_raise ArgumentError, fn ->
      multiply(column_vector, row_vector) end
  end

  test "multiply if 2 row vectors are multiplied returns elementwise multiplication" do
    v1 = [[1,3,5]]
    v2 = [[3,3,3]]
    assert [[3,9,15]] == multiply(v1, v2)
  end

  test "multiply if 2 column vectors are multiplied returns elementwise multiplication" do
    v1 = [[1],[3],[5]]
    v2 = [[3],[3],[3]]
    assert [[3],[9],[15]] == multiply(v1, v2)
  end

  test "multiply if square matrix multiplied with column vector returns column vector" do
    square_matrix = [[2,3], [3,5]]
    column_vector = [[4], [9]]
    result = multiply(square_matrix, column_vector)
    assert result == [[35], [57]]
  end

  test "multiply if square matrices multiplied produce square matrix" do
    x = [[2,3], [3,5]]
    y = [[1,2], [5,-1]]
    z = multiply(x, y)
    assert z == [[17, 1], [28, 1]]
  end

  test "multiply if different sized matrices yield proper sized matrix" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    y = [[12,13,14],
         [15,16,17]] # 2x3
    result = multiply(x, y)
    assert {4,3} == size(result)
  end

  test "multiply if different sized matrices that do not fit raise exception" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    y = [[12,13,14]] # 1x3
    # 1st matrix's column count has to be equal to 2nd matrix's row count
    assert_raise ArgumentError, fn ->
      multiply(x,y) end
  end

  test "multiply if second argument is number does a scalar multiplication" do
    x = [[1,2],
         [3,4],
         [5,6],
         [7,8]] # 4x2
    assert multiply(x, 2) == [[2,4],
                              [6,8],
                              [10,12],
                              [14,16]]
  end

  test "dot_product if two row vectors passed returns good result" do
    v1 = [[1,2,3]]
    v2 = [[2,2,2]]
    assert 12 == dot_product(v1, v2)
  end

  test "dot_product if two column vectors passed returns good result" do
    v1 = [[1],[2],[3]]
    v2 = [[2],[2],[2]]
    assert 12 == dot_product(v1, v2)
  end

  test "dot_product if row and column vectors passed in either order returns good result" do
    column_vector = [[2],[3],[4]]
    row_vector = [[4,5,6]]
    assert 4*2 + 5*3 + 6*4 == dot_product(column_vector, row_vector)
    assert 4*2 + 5*3 + 6*4 == dot_product(row_vector, column_vector)
  end

  test "dot_product if two regular matrices are passed raises an ArgumentError" do
    m1 = [[3,7], [12,55]]
    m2 = [[6,44], [3,6]]
    assert_raise ArgumentError, fn ->
      dot_product(m1, m2)
    end
  end

  test "dot_product if vector is multiplied by matrix raises ArgumentError" do
    row_vector = [[4,5,6]]
    column_vector = [[2,44],[3,5],[4,999]]
    assert_raise ArgumentError, fn ->
      dot_product(row_vector, column_vector)
    end
  end

  test "pmultiply if 2 matrices are passed returns good matrix" do
    x = [[2,3], [3,5]]
    y = [[1,2], [5,-1]]
    z = pmultiply(x, y)
    assert z == [[17, 1], [28, 1]]
  end

  test "pmultiply if 2 big matrices are passed returns good matrix" do
    random_a = random_cells(50, 50, 100)
    random_b = random_cells(50, 50, 100)
    result = pmultiply(random_a, random_b)
    assert length(result) == 50
  end

  test "apply to add 2 to every number actually does it" do
    x = [[3,4], [9,88]]
    assert [[5,6], [11, 90]] == ExMatrix.apply(x, fn x -> x + 2 end)
  end
end
