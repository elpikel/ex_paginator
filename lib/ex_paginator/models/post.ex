defmodule ExPaginator.Models.Post do
  use Ecto.Schema

  schema("posts") do
    field(:title, :string)
    field(:body, :string)

    has_many(:comments, ExPaginator.Models.Post)
    belongs_to(:user, ExPaginator.Models.User)
  end
end
