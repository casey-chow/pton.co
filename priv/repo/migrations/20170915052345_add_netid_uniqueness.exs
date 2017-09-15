defmodule Pton.Repo.Migrations.AddNetidUniqueness do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:netid])
  end
end
