defmodule Pton.Repo.Migrations.CreateSlugIndex do
  use Ecto.Migration

  def change do
    create unique_index(:links, [:slug])
  end
end
