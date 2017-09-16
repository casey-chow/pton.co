defmodule Pton.Redirection.UserLink do
  @moduledoc """
  Schema for the join table between users and links.
  """
  use Ecto.Schema

  schema "users_links" do
    belongs_to :link, Pton.Redirection.Link
    belongs_to :user, Pton.Accounts.User
  end
end
