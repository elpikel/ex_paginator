defmodule ExPaginator do
  import Ecto.Query

  alias ExPaginator.Meta
  alias ExPaginator.Repo

  def paginate(query, opts) do
    fields = opts[:fields]
    limit = opts[:limit]
    previous_cursor = Meta.decode(opts[:cursor])
    cursor_function = opts[:cursor_function]
    direction = opts[:direction] || :forward

    entries =
      query
      |> set_cursor(previous_cursor, direction)
      |> limit(^limit)
      |> Repo.all()

    total = Repo.aggregate(query, :count)

    cursor = cursor(fields, entries, cursor_function)

    %Meta{
      total: total,
      entries: entries,
      cursor: cursor
    }
  end

  defp cursor(_fields, [], _cursor_function), do: ""

  defp cursor(fields, entries, cursor_function) do
    last = last_entry(entries)

    fields
    |> Enum.reduce(%{}, fn
      {{table, field}, order}, acc ->
        Map.put(acc, field, %{table: table, value: cursor_function.(last), order: order})

      {field, order}, acc ->
        Map.put(acc, field, %{value: Map.get(last, field), order: order, table: nil})
    end)
    |> Meta.encode()
  end

  defp last_entry(entries) do
    Enum.at(entries, Enum.count(entries) - 1)
  end

  defp set_cursor(query, nil, _direction), do: query

  defp set_cursor(query, cursor, direction) do
    cursor
    |> Map.keys()
    |> Enum.reduce(query, fn column, query ->
      %{table: table, value: value, order: order} = Map.get(cursor, column)

      order(query, order, table, column, value, direction)
    end)
  end

  defp order(query, :desc, table, column, value, :forward) do
    case table do
      nil ->
        where(query, ^dynamic([q], field(q, ^column) < ^value))

      table ->
        where(query, ^dynamic([{^table, q}], field(q, ^column) < ^value))
    end
  end

  defp order(query, :desc, table, column, value, :backward) do
    case table do
      nil ->
        where(query, ^dynamic([q], field(q, ^column) >= ^value))

      table ->
        where(query, ^dynamic([{^table, q}], field(q, ^column) >= ^value))
    end
  end

  defp order(query, :asc, table, column, value, :forward) do
    case table do
      nil ->
        where(query, ^dynamic([q], field(q, ^column) > ^value))

      table ->
        where(query, ^dynamic([{^table, q}], field(q, ^column) > ^value))
    end
  end

  defp order(query, :asc, table, column, value, :backward) do
    case table do
      nil ->
        where(query, ^dynamic([q], field(q, ^column) <= ^value))

      table ->
        where(query, ^dynamic([{^table, q}], field(q, ^column) >= ^value))
    end
  end
end
