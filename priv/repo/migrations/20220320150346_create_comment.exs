defmodule ExPaginator.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:body, :string)
      add(:user_id, references(:users))
      add(:post_id, references(:posts))
    end
  end
end
