defmodule ExMatrixParallelMultiplicationTest do
  use ExUnit.Case
  import ExMatrix

  test "simple parallel multiply" do
    x = [[2,3], [3,5]]
    y = [[1,2], [5,-1]]
    z = pmultiply(x, y)
    assert z == [[17, 1], [28, 1]]
  end

  test "large matrix parallel" do
    random_a = random_cells(50, 50, 100)
    random_b = random_cells(50, 50, 100)
    result = pmultiply(random_a, random_b)
    assert length(result) == 50
  end
end
