defmodule ExPaginatorTest do
  use ExUnit.Case
  doctest ExPaginator

  test "paginate" do
    assert ExPaginator.paginate() == nil
  end
end
