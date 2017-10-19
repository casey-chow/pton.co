defmodule Pton.Redirection.Link do
  @moduledoc """
  Data layer for links and redirection,  including all valdiation code.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Pton.Redirection.Link

  schema "links" do
    field :slug, :string
    field :url, :string
    field :is_safe, :boolean

    timestamps()

    many_to_many :owners, Pton.Accounts.User,
      join_through: "users_links",
      on_delete: :delete_all
  end

  @doc false
  def changeset(%Link{} = link, attrs) do
    host = Application.get_env(:pton, PtonWeb.Endpoint)[:url][:host]

    link
    |> cast(attrs, [:slug, :url])
    |> validate_required([:url])
    |> validate_url(:url, message: "invalid url")
    |> validate_not_host(:url, host: host, message: "url cannot be from this site")
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

  @valid_url ~r"^[A-Za-z][A-Za-z\d.+-]*:\/*(?:\w+(?::\w+)?@)?[^\s/]+(?::\d+)?(?:\/[\w#!:.?+=&%@\-/]*)?$"
  defp validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      if Regex.match?(@valid_url, url) do
        []
      else
        [{field, options[:message] || "invalid url"}]
      end
    end
  end

  defp validate_not_host(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      url_parsed = URI.parse(url)
      if url_parsed.host != options[:host] do
        []
      else
        [{field, options[:message] || "invalid host"}]
      end
    end
  end

end
