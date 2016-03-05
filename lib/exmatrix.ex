defmodule ExMatrix do
  @moduledoc """
  ExMatrix is an Elixir library implementing a parallel matrix multiplication
  algorithm and other utilitiy functions for working with matrices.

  ## Multiplying matrices

      iex> x = [[2,3], [3,5]]
      [[2,3], [3,5]]
      iex> y = [[1,2], [5,-1]]
      [[1,2], [5,-1]]
      iex> ExMatrix.pmultiply(x, y)
      [[17, 1], [28, 1]]
      iex> ExMatrix.multiply(x, y)
      [[17, 1], [28, 1]]

  """

  ## MATRIX GENERATION
  ## MATRIX GENERATION
  ## MATRIX GENERATION

  @doc """
  Creates a new matrix that has ```rows``` number of rows and
  ```cols``` columns. All cells are set to the value of the third parameter

  # Example
      iex> ExMatrix.new_matrix(4, 4, 5)
      [[4, 4, 4, 4, 4], [4, 4, 4, 4, 4], [4, 4, 4, 4, 4], [4, 4, 4, 4, 4]]
  """
  @spec new_matrix(number, non_neg_integer, non_neg_integer) :: [[number]]
  def new_matrix(value, rows, cols) when is_number(value) do
    for _ <- 1 .. rows, do: generate_filled_row(cols, value)
  end

  def new_matrix(items, rows, cols) when is_list(items) do
    if rows * cols != length(items), do: raise ArgumentError, "List contains #{length(items)} elements instead of #{rows*cols}"
    Enum.chunk(items, cols)
  end

  @doc """
  Generates a `matrix` with `rows` and `cols` as row and column number. The
  cell values will be 0 for every cell

  ## Example
      iex> ExMatrix.zeroes(4, 5)
      [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
  """
  def zeroes(rows, cols) do
    for _ <- 1 .. rows, do: generate_filled_row(cols, 0)
  end

  @doc """
  Generates a `matrix` with `rows` and `cols` as row and column number. The
  cell values will be 1 for every cell

  ## Example
      iex> ExMatrix.ones(4, 5)
      [[1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]
  """
  def ones(rows, cols) do
    for _ <- 1 .. rows, do: generate_filled_row(cols, 1)
  end

  @doc """
  Generates an Identity Matrix with 'size' rows and columns

  ## Example
      iex> ExMatrix.identity(4, 5)
      [[1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]]
  """
  @spec identity(non_neg_integer) :: [[number]]
  def identity(size) do
    _identity(size, 0, [])
  end

  defp _identity(size, pos, matrix) when size == pos, do: matrix
  defp _identity(size, pos, matrix) do
    row = generate_filled_row(size, 0) |> List.replace_at(pos, 1)
    _identity(size, pos + 1, matrix |> List.insert_at(-1, row))
  end

  @docp """
  Generates a zero-filled list of ```size``` elements, primarily used
  by the default new_matrix function.
  """
  @spec generate_filled_row(non_neg_integer, number) :: [number]
  defp generate_filled_row(size, value) do
    Enum.map(:lists.seq(1, size), fn _ -> value end)
  end

  @doc """
  Generates a random matrix with integers where the cells will be between
  0..`max`
  """
  @spec random_cells(integer, integer, integer) :: [[number]]
  def random_cells(rows, cols, max) when is_integer(max) do
    :random.seed(:erlang.timestamp)

    Enum.map(:lists.seq(1, rows), fn(_)->
      :lists.seq(1, cols)
      |> Enum.map(fn(_)-> :random.uniform(max) end)
    end)
  end

  @doc """
  Generates a random matrix with float numbers with default precision where
  the cells will be between 0..`max`
  """
  @spec random_cells(integer, integer, float) :: [[float]]
  def random_cells(rows, cols, max) when is_float(max) do
    :random.seed(:erlang.timestamp)

    Enum.map(:lists.seq(1, rows), fn(_)->
      :lists.seq(1, cols)
      |> Enum.map(fn(_)-> :random.uniform * max end)
    end)
  end

  @doc """
  Generates a random matrix with float numbers with given precision where
  the cells will be between 0..`max`
  """
  @spec random_cells(integer, integer, float, integer) :: [[float]]
  def random_cells(rows, cols, max, precision) when is_float(max) do
    :random.seed(:erlang.timestamp)

    Enum.map(:lists.seq(1, rows), fn(_)->
      :lists.seq(1, cols)
      |> Enum.map(fn(_)-> Float.round(:random.uniform * max, precision) end)
    end)
  end

  ## MANIPULATION
  ## MANIPULATION
  ## MANIPULATION

  @doc """
  Transposes the provided ```matrix``` so that a 3, 2 matrix would become
  a 2, 3 matrix. Once transposed the first row in the transposed matrix is
  actually the first column in the pre-transposed matrix.

  # Example
      iex> ExMatrix.transpose([[2, 4],[5, 6]])
      [[2, 5], [4, 6]]
  """
  @spec transpose([[number]]) :: [[number]]
  def transpose(cells) do
    _transpose(cells)
  end

  defp _transpose([[]|_]), do: []
  defp _transpose(cells) when is_list(cells) do
    [ Enum.map(cells, fn(x) -> hd(x) end) | _transpose(Enum.map(cells, fn(x) -> tl(x) end))]
  end


  @doc """
  Perform a sequential multiplication of the two matrices,
  ```matrix_a``` and ```matrix_b```.
  """
  @spec multiply([[number]], [[number]]) :: [[number]]
  def multiply(matrix_a, matrix_b) when is_list(matrix_a) and is_list(matrix_b) do
    if (not is_matrix(matrix_a) or not is_matrix(matrix_b)) do
      raise ArgumentError, "Only matrices can be set as parameters"
    end
    if is_vector(matrix_a) and is_vector(matrix_b) do
      multiply_elementwise(matrix_a, matrix_b)
    else
      multiply_matrices(matrix_a, matrix_b)
    end
  end
  def multiply(matrix, number) when is_list(matrix) and is_number(number) do
    if not is_matrix(matrix) do
      raise ArgumentError, "Only matrix can be set as first parameter"
    end

    ExMatrix.apply(matrix, fn x -> x * number end)
  end
  def multiply(_, _), do: raise ArgumentError, "Only matrices can be set as parameters"

  defp multiply_elementwise(vector_a, vector_b) do
    if (is_column_vector(vector_a) and is_row_vector(vector_b) or
    is_row_vector(vector_a) and is_column_vector(vector_b)) do
      raise ArgumentError, "Only the same type of vectors can be multiplied elementwise"
    end

    result = Stream.zip(
      vector_a |> vector_to_list,
      vector_b |> vector_to_list
      )
      |> Enum.map(fn({x, y}) -> x * y end)
    cond do
      is_row_vector(vector_a) and is_row_vector(vector_b) ->
        {_, cols} = size(vector_a)
        new_matrix(result, 1, cols)
      is_column_vector(vector_a) and is_column_vector(vector_b) ->
        {rows, _} = size(vector_a)
        new_matrix(result, rows, 1)
      true ->
        []
    end
  end

  defp multiply_matrices(matrix_a, matrix_b) do
    with {_, col_a} = size(matrix_a),
         {row_b, _} = size(matrix_b),
    do:
      if col_a != row_b, do: raise ArgumentError, "The column count of the 1st matrix has be equal to the row count of the 2nd matrix"

    transposed_b = transpose(matrix_b)

    result = Enum.map(matrix_a, fn(row)->
      Enum.map(transposed_b, &dot_product(row, &1))
    end)
    case length(List.flatten(result)) do
      1 ->
        # If it's a scalar, return just the scalar
        result 
        |> List.flatten
        |> Enum.at(0)
      _ ->
        result
    end
  end

  @spec get_row([[number]], integer) :: [number]
  def get_row(matrix, n) when is_list(matrix) and is_integer(n) do
    if not is_matrix(matrix), do: raise ArgumentError, "Only matrices should be passed as a first parameter"
    matrix 
    |> Enum.at(n)
  end
  def get_row(_, _), do: raise ArgumentError, "Only a matrix and an integer should be passed"

  @spec get_column([[number]], integer) :: [number]
  def get_column(matrix, n) when is_list(matrix) and is_integer(n) do
    if not is_matrix(matrix), do: raise ArgumentError, "Only matrices should be passed as a first parameter"
    matrix
    |> Enum.map(fn row -> Enum.at(row, n) end)
    |> List.flatten
  end
  def get_column(_, _), do: raise ArgumentError, "Only a matrix and an integer should be passed"

  @doc """
  Perform a scalar division on the matrix
  """
  @spec divide_scalar([[number]], number) :: [[number]]
  def divide_scalar(matrix, scalar) when is_number(scalar) and scalar != 0 do
    if not is_matrix(matrix), do: raise ArgumentError, "Only matrices should be passed as a first parameter"
    matrix
    |> Enum.map(fn row ->
      Enum.map(row, fn cell ->
        Float.round(cell / scalar, 10)
      end)
    end)
  end

  @doc """
  Perform a parallel multiplication of the two matrices,
  ```matrix_a``` and ```matrix_b```.
  """
  @spec pmultiply([[number]], [[number]]) :: [[number]]
  def pmultiply(matrix_a, matrix_b) do
    new_b = transpose(matrix_b)

    pmap(matrix_a, fn(row)->
      Enum.map(new_b, &dot_product(row, &1))
    end)
  end

  @docp """
  Perform a parallel map by calling the function against each element
  in a new process.
  """
  @spec pmap([number], fun) :: [number]
  defp pmap(collection, function) do
    me = self

    collection
    |> Enum.map(fn (elem) ->
      spawn_link fn -> (send me, { self, function.(elem) }) end
    end)
    |> Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end

  @doc """
  Adds two matrices of the same dimensions, returning a new matrix of the
  same dimensions.  If two non-matching matrices are provided an ArgumentError
  will be raised.
  """
  @spec add([[number]], [[number]]) :: [[number]]
  def add(matrix_a, matrix_b) do
    case size(matrix_a) == size(matrix_b) do
      false -> raise ArgumentError, message: "Cannot add matrices of different dimensions"
      _ -> nil
    end

    Stream.zip(matrix_a, matrix_b)
    |> Enum.map(fn({a,b})-> add_rows(a, b) end)
  end

  @doc """
  Subtracts two matrices of the same dimensions, returning a new matrix of the
  same dimensions.  If two non-matching matrices are provided an ArgumentError
  will be raised.
  """
  @spec subtract([[number]], [[number]]) :: [[number]]
  def subtract(matrix_a, matrix_b) do
    case size(matrix_a) == size(matrix_b) do
      false -> raise ArgumentError, message: "Cannot add matrices of different dimensions"
      _ -> nil
    end

    Stream.zip(matrix_a, matrix_b)
    |> Enum.map(fn({a,b})-> subtract_rows(a, b) end)
  end

  @doc """
  Returns the size of the matrix as {rows, columns}.
  """
  @spec size([[number]]) :: {number, number}
  def size(matrix) when is_list(matrix) do
    case is_list(hd(matrix)) do
      true ->
        {length(matrix), length(Enum.at(matrix, 0))}
      _ ->
        {0, 0}
    end
  end

  @doc """
  Calculates the dot-product for two rows of numbers
  """
  @spec dot_product([[number]], [[number]]) :: number
  def dot_product(vector_a, vector_b) when is_list(vector_a) and is_list(vector_b) do
    # If both of them are matrices and not row or column vectors, do regular 
    # matrix multiplication
    if (is_matrix(vector_a) and is_matrix(vector_b) and 
    (not is_vector(vector_a) or not is_vector(vector_b))) do
      raise ArgumentError, "Cannot use dot_product on non-vector matrices"
    else
      row_a = case is_vector(vector_a) do
        true ->
          vector_a |> vector_to_list
        _ ->
          vector_a
      end
      row_b = case is_vector(vector_b) do
        true ->
          vector_b |> vector_to_list
        _ ->
          vector_b
      end
      Stream.zip(row_a, row_b)
      |> Enum.map(fn({x, y}) -> x * y end)
      |> Enum.sum
    end
  end

  def is_row_vector(vector) do
    with {rows, _} = size(vector),
    do:
      is_matrix(vector) and rows == 1
  end

  def is_column_vector(vector) do
    with {_, cols} = size(vector),
    do:
      is_matrix(vector) and cols == 1
  end

  def is_vector(vector) do
    is_matrix(vector) and (is_column_vector(vector) or is_row_vector(vector))
  end

  def vector_to_list(vector) do
    cond do
      not is_vector(vector) -> raise ArgumentError, "Only vectors can be passed as parameters"
      is_row_vector(vector) -> Enum.at(vector, 0)
      is_column_vector(vector) -> vector |> transpose |> Enum.at(0)
      true -> []
    end
  end

  @doc """
  Adds two rows together to return a new row
  """
  @spec add_rows([number], [number]) :: [number]
  def add_rows(row_a, row_b) do
    Stream.zip(row_a, row_b)
    |> Enum.map(fn({x, y}) -> x + y end)
  end

  @doc """
  Subtracts two rows to return a new row
  """
  @spec subtract_rows([number], [number]) :: [number]
  def subtract_rows(row_a, row_b) do
    Stream.zip(row_a, row_b)
    |> Enum.map(fn({x, y}) -> x - y end)
  end

  @doc """
  Append multiple rows to a matrix
  """
  @spec append_rows([[number]], [[number]]) :: [[number]]
  def append_rows(matrix, rows) when is_list(matrix) and is_list(rows) do
    if Enum.any?(rows, fn x -> !is_list(x) or Enum.any?(x, fn y -> !is_number(y) end) end) do
      raise "One of the rows has bad format"
    end
    {_, cols} = size(matrix)
    if Enum.all?(rows, fn x -> is_list(x) and length(x) == cols end) do
      Enum.reduce(rows, matrix, fn(row, mx) -> List.insert_at(mx, -1, row) end)
    else
      raise "One of the rows has a different length than the matrix's column length"
    end
  end
  def append_rows(_, _), do: raise "Matrix and rows have to be lists"

  @doc """
  Append 1 row to a matrix
  """
  @spec append_row([[number]], [number]) :: [[number]]
  def append_row(matrix, row) when is_list(matrix) and is_list(row) do
    if is_bitstring(row) or Enum.any?(row, fn x -> !is_number(x) end) do
      raise "The row has bad format"
    end
    {_, cols} = size(matrix)
    if length(row) == cols do
      List.insert_at(matrix, -1, row)
    else
      raise "The row has a different length than the matrix's column length"
    end
  end
  def append_row(_, _), do: raise "Matrix and row have to be lists"

  @doc """
  Append multiple columns to a matrix
  """
  @spec append_cols([[number]], [[number]]) :: [[number]]
  def append_cols(matrix, cols) when is_list(matrix) and is_list(cols) do
    if Enum.any?(cols, fn x -> !is_list(x) or Enum.any?(x, fn y -> !is_number(y) end) end) do
      raise "One of the cols has bad format"
    end
    {rows, _} = size(matrix)
    if Enum.all?(cols, fn x -> is_list(x) and length(x) == rows end) do
      #Enum.reduce(cols, matrix, fn(col, mx) -> mx |> Enum.zip(col) |> Enum.map(fn {row, col_item} -> List.insert_at(row, -1, col_item) end) end)
      Enum.reduce(cols, matrix, fn(col, mx) -> do_append_col(mx, col) end)
    else
      raise "One of the cols has a different length than the matrix's column length"
    end
  end
  def append_cols(_, _), do: raise "Matrix and cols have to be lists"

  @doc """
  Append 1 column to a matrix
  """
  @spec append_col([[number]], [number]) :: [[number]]
  def append_col(matrix, col) when is_list(matrix) and is_list(col) do
    if is_bitstring(col) or Enum.any?(col, fn x -> !is_number(x) end) do
      raise "The column has bad format"
    end
    {rows, _} = size(matrix)
    if length(col) == rows do
      do_append_col(matrix, col)
    else
      raise "The column has a different length than the matrix's row length"
    end
  end
  def append_col(_, _), do: raise "Matrix and col have to be lists"

  defp do_append_col(matrix, col) do
      matrix 
      |> Enum.zip(col)
      |> Enum.map(fn {row, col_item} -> List.insert_at(row, -1, col_item) end)
  end

  @doc """
  Apply a function to each element of a matrix
  """
  def apply(matrix, fun) do
    if not is_matrix(matrix), do: raise ArgumentError, "Only matrices should be passed as a first parameter"
    matrix
    |> Enum.map(fn row ->
      Enum.map(row, fn cell ->
        fun.(cell)
      end)
    end)
  end

  @doc """
  Check if the passed argument `matrix` is truly a matrix

  ## Example
      iex> x = [[2,3], [3,5]]
      [[2,3], [3,5]]
      iex> ExMatrix.is_matrix(x)
      true
      iex> x = "bear"
      "bear"
      iex> ExMatrix.is_matrix(x)
      false
  """
  def is_matrix(matrix) do
    with list? = is_list(matrix),
         {_, col_size} = size(matrix),
         rows_are_ok = Enum.all?(matrix, fn x -> is_list(x) and length(x) == col_size end),
    do:
      list? and rows_are_ok
  end
end
