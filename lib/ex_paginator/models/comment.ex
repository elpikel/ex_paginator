defmodule ExPaginator.Models.Comment do
  use Ecto.Schema

  schema("comments") do
    field(:body, :string)

    belongs_to(:comment, ExPaginator.Models.Comment)
    belongs_to(:user, ExPaginator.Models.User)
  end
end
