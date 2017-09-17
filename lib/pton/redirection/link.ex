defmodule Pton.Redirection.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pton.Redirection.Link

  schema "links" do
    field :slug, :string
    field :url, :string

    timestamps()

    many_to_many :owners, Pton.Accounts.User,
      join_through: "users_links",
      on_delete: :delete_all
  end

  @doc false
  def changeset(%Link{} = link, attrs) do
    link
    |> cast(attrs, [:slug, :url])
    |> validate_required([:url])
    |> unique_constraint(:slug)
  end
end
