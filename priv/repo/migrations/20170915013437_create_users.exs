defmodule Pton.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :netid, :string
      add :provider, :string
      add :token, :string

      timestamps()
    end

  end
end
