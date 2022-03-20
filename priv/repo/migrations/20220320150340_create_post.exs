defmodule ExPaginator.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string)
      add(:body, :string)
      add(:user_id, references(:users))
    end
  end
end
