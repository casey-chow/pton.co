defmodule Pton.Repo.Migrations.CreateUsersLinks do
  use Ecto.Migration

  def change do
    create table(:users_links) do
      add :user_id, references(:users)
      add :link_id, references(:links)
    end

    create unique_index(:users_links, [:user_id, :link_id])
  end
end
