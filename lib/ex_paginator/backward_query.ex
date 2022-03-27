defmodule ExPaginator.BackwardQuery do
  import Ecto.Query

  def where(query, :desc, table, column, value) do
    case table do
      nil ->
        where(query, ^dynamic([q], field(q, ^column) >= ^value))

      table ->
        where(query, ^dynamic([{^table, q}], field(q, ^column) >= ^value))
    end
  end

  def where(query, :asc, table, column, value) do
    case table do
      nil ->
        where(query, ^dynamic([q], field(q, ^column) <= ^value))

      table ->
        where(query, ^dynamic([{^table, q}], field(q, ^column) >= ^value))
    end
  end
end
