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
    |> validate_url(:url, message: "invalid url")
    |> validate_slug_format
    |> unique_constraint(:slug)
  end

  defp validate_slug_format(changeset) do
    slug = get_field(changeset, :slug)

    if slug != nil and not Regex.match?(~r/^[A-Za-z0-9\_\-\+]+$/, slug) do
      add_error(changeset, :slug, "should be only contain letters, numbers," <>
                                  "underscore (_), dash (-) or plus (+)")
    else
      changeset
    end
  end

  # http://blog.danielberkompas.com/elixir/2015/05/20/useful-ecto-validators.html
  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_charlist |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end

end
