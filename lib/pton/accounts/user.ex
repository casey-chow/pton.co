defmodule Pton.Accounts.User do
  @moduledoc """
  Contains data layer for users schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Pton.Accounts.User

  schema "users" do
    field :netid, :string
    field :provider, :string
    field :token, :string

    timestamps()

    many_to_many :links, Pton.Redirection.Link,
      join_through: "users_links",
      on_delete: :delete_all
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:netid, :provider, :token])
    |> validate_required([:netid, :provider, :token])
    |> unique_constraint(:netid)
  end
end
