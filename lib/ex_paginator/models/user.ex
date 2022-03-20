defmodule ExPaginator.Models.User do
  use Ecto.Schema

  schema("users") do
    field(:name, :string)

    has_many(:posts, ExPaginator.Models.Post)
    has_many(:comments, ExPaginator.Models.Comment)
  end
end
