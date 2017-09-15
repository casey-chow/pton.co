defmodule Pton.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pton.User


  schema "users" do
    field :netid, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:netid, :provider, :token])
    |> validate_required([:netid, :provider, :token])
  end
end
