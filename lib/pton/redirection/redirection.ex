defmodule Pton.Redirection do
  @moduledoc """
  The Redirection context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Pton.Repo
  alias Pton.Accounts.User
  alias Pton.Redirection.Link
  alias Pton.Redirection.Random
  alias Pton.Redirection.SafeBrowsing

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link) |> Repo.preload(:owners)
  end

  @doc """
  Returns the list of links that the user owns.

  ## Examples

      iex> list_links(user)
      [%Link{}, ...]

  """
  def user_links(%User{} = user) do
    Repo.all(Ecto.assoc(user, :links))
    |> Repo.preload(:owners)
  end

  @doc """
  Returns the number of links the user owns.

  ## Examples

      iex> count_user_links(user)
      3

  """
  def count_user_links(%User{} = user) do
    Repo.aggregate(Ecto.assoc(user, :links), :count, :id)
  end


  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id) do
    Repo.get!(Link, id) |> Repo.preload(:owners)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link_by!(clauses) do
    Repo.get_by!(Link, clauses) |> Repo.preload(:owners)
  end

  @doc """
  Checks a link to see if it is safe, and records in the database the outcome
  of the check. If the link does not exist, raises `Ecto.NoResultsError`.
  Returns whether the url is safe.
  """
  def check_link!(id) do
    link = Repo.get!(Link, id)
    is_safe = SafeBrowsing.is_safe? link.url

    {:ok, _} = link
    |> Link.safety_changeset(%{is_safe: is_safe})
    |> Repo.update()

    is_safe
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(user, %{field: value})
      {:ok, %Link{}}

      iex> create_link(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(user, attrs \\ %{}) do
    attrs = if is_nil(Map.get(attrs, "slug"))
               or String.trim(Map.get(attrs, "slug")) == "" do
      Map.put(attrs, "slug", Random.string(5))
    else
      attrs
    end

    if count_user_links(user) >= Application.fetch_env!(:pton, :max_lifetime_links) do
      raise Pton.QuotaExceededError
    end

    maybe_link = %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()

    case maybe_link do
      {:ok, link} ->
        link
        |> Repo.preload(:owners)
        |> change()
        |> put_assoc(:owners, [user])
        |> Repo.update()

        {:ok, link}

      _ -> maybe_link
    end
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Link.

  ## Examples

      iex> delete_link(user, link)
      {:ok, %Link{}}

      iex> delete_link(user, link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{source: %Link{}}

  """
  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end

  @doc """
  Utility function, returns whether a user owns the link.
  """
  def is_owner?(nil = _user, _link), do: false
  def is_owner?(%User{} = user, %Link{} = link) do
    not is_nil(user)
    and not is_nil(link)
    and Enum.any? link.owners, fn(owner) -> owner.id == user.id end
  end
end
