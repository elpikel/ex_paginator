defmodule ExPaginator.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias ExPaginator.Repo

      import Ecto
      import Ecto.Query
      import ExPaginator.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ExPaginator.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ExPaginator.Repo, {:shared, self()})
    end

    :ok
  end
end
