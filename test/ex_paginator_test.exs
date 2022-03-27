defmodule ExPaginatorTest do
  use ExPaginator.RepoCase

  alias ExPaginator.Models
  alias ExPaginator.Options

  test "paginate backward and forward" do
    for i <- 1..5 do
      Repo.insert!(%Models.User{name: "user_#{i}"})
    end

    query =
      Models.User
      |> order_by([u], asc: u.name)
      |> select([u], u)

    paginator =
      ExPaginator.paginate(query, %Options{fields: [{:name, :asc}], limit: 2, direction: :forward})

    assert paginator.total == 5
    assert [%{name: "user_1"}, %{name: "user_2"}] = paginator.entries

    paginator =
      ExPaginator.paginate(
        query,
        %Options{
          fields: [{:name, :asc}],
          limit: 2,
          cursor: paginator.cursor,
          direction: :backward
        }
      )

    assert paginator.total == 5
    assert [%{name: "user_1"}, %{name: "user_2"}] = paginator.entries

    paginator =
      ExPaginator.paginate(
        query,
        %Options{fields: [{:name, :asc}], limit: 2, cursor: paginator.cursor, direction: :forward}
      )

    assert paginator.total == 5
    assert [%{name: "user_3"}, %{name: "user_4"}] = paginator.entries
  end

  test "paginate on association" do
    for i <- 1..5 do
      Repo.insert(%Models.Post{
        user: %Models.User{name: "user_#{i}"},
        title: "title_#{i}",
        body: "body_#{i}"
      })
    end

    query =
      Models.Post
      |> join(:left, [p], u in assoc(p, :user), as: :user)
      |> preload(:user)
      |> order_by([user: u], asc: u.name)
      |> select([u], u)

    paginator =
      ExPaginator.paginate(
        query,
        %Options{
          fields: [{{:user, :name}, :asc}],
          limit: 2,
          cursor_function: fn post -> post.user.name end
        }
      )

    assert paginator.total == 5
    assert [%{user: %{name: "user_1"}}, %{user: %{name: "user_2"}}] = paginator.entries

    paginator =
      ExPaginator.paginate(
        query,
        %Options{
          fields: [{{:user, :name}, :asc}],
          limit: 2,
          cursor: paginator.cursor,
          cursor_function: fn post -> post.user.name end
        }
      )

    assert paginator.total == 5
    assert [%{user: %{name: "user_3"}}, %{user: %{name: "user_4"}}] = paginator.entries

    paginator =
      ExPaginator.paginate(
        query,
        %Options{
          fields: [{{:user, :name}, :asc}],
          limit: 2,
          cursor: paginator.cursor,
          cursor_function: fn post -> post.user.name end
        }
      )

    assert paginator.total == 5
    assert [%{user: %{name: "user_5"}}] = paginator.entries
  end

  test "paginate on asc" do
    for i <- 1..5 do
      Repo.insert!(%Models.User{name: "user_#{i}"})
    end

    query =
      Models.User
      |> order_by([u], asc: u.name)
      |> select([u], u)

    paginator = ExPaginator.paginate(query, %Options{fields: [{:name, :asc}], limit: 2})

    assert paginator.total == 5
    assert [%{name: "user_1"}, %{name: "user_2"}] = paginator.entries

    paginator =
      ExPaginator.paginate(query, %Options{
        fields: [{:name, :asc}],
        limit: 2,
        cursor: paginator.cursor
      })

    assert paginator.total == 5
    assert [%{name: "user_3"}, %{name: "user_4"}] = paginator.entries

    paginator =
      ExPaginator.paginate(query, %Options{
        fields: [{:name, :asc}],
        limit: 2,
        cursor: paginator.cursor
      })

    assert paginator.total == 5
    assert [%{name: "user_5"}] = paginator.entries
  end

  test "paginate on desc" do
    for i <- 1..5 do
      Repo.insert!(%Models.User{name: "user_#{i}"})
    end

    query =
      Models.User
      |> order_by([u], desc: u.name)
      |> select([u], u)

    paginator = ExPaginator.paginate(query, %Options{fields: [{:name, :desc}], limit: 2})

    assert paginator.total == 5
    assert [%{name: "user_5"}, %{name: "user_4"}] = paginator.entries

    paginator =
      ExPaginator.paginate(query, %Options{
        fields: [{:name, :desc}],
        limit: 2,
        cursor: paginator.cursor
      })

    assert paginator.total == 5
    assert [%{name: "user_3"}, %{name: "user_2"}] = paginator.entries

    paginator =
      ExPaginator.paginate(query, %Options{
        fields: [{:name, :desc}],
        limit: 2,
        cursor: paginator.cursor
      })

    assert paginator.total == 5
    assert [%{name: "user_1"}] = paginator.entries
  end
end
