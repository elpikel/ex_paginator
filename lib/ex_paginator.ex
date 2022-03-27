defmodule ExPaginator do
  defstruct entries: [], total: 0, cursor: ""
  import Ecto.Query

  alias ExPaginator.BackwardQuery
  alias ExPaginator.ForwardQuery
  alias ExPaginator.Options
  alias ExPaginator.Repo

  def paginate(query, %Options{} = opts) do
    entries =
      query
      |> by_cursor(Options.decode(opts.cursor), opts.direction)
      |> limit(^opts.limit)
      |> Repo.all()

    total = Repo.aggregate(query, :count)

    cursor =
      entries
      |> last_entry()
      |> cursor(opts.fields, opts.cursor_function)

    %ExPaginator{
      total: total,
      entries: entries,
      cursor: cursor
    }
  end

  defp cursor(_fields, _cursor_function, []), do: ""

  defp cursor(last_entry, fields, cursor_function) do
    fields
    |> Enum.reduce(%{}, fn
      {{table, column}, order}, acc ->
        Map.put(acc, column, %{table: table, value: cursor_function.(last_entry), order: order})

      {column, order}, acc ->
        Map.put(acc, column, %{table: nil, value: Map.get(last_entry, column), order: order})
    end)
    |> Options.encode()
  end

  defp last_entry(entries) do
    Enum.at(entries, Enum.count(entries) - 1)
  end

  defp by_cursor(query, nil, _direction), do: query

  defp by_cursor(query, cursor, direction) do
    cursor
    |> Map.keys()
    |> Enum.reduce(query, fn column, query ->
      %{table: table, value: value, order: order} = Map.get(cursor, column)

      case direction do
        :forward ->
          ForwardQuery.where(query, order, table, column, value)

        _ ->
          BackwardQuery.where(query, order, table, column, value)
      end
    end)
  end
end
