defmodule Pton.Repo.Migrations.UrlIsSafe do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:links) do
      add :is_safe, :boolean, default: false, null: false
    end

    flush()

    from(l in "links", update: [set: [is_safe: true]])
    |> Pton.Repo.update_all([])
  end

  def down do
    alter table(:links) do
      remove :is_safe
    end

    flush()

    from(l in "links", update: [set: [is_safe: true]])
    |> Pton.Repo.update_all([])
  end
end
