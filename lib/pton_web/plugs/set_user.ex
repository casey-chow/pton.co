defmodule Pton.Plugs.SetUser do
  @moduledoc """
  Plug to set the current user based on CAS authentication.
  """
  import Plug.Conn

  alias Pton.Repo
  alias Pton.Accounts.User

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      user_id = get_session(conn, :user_id)

      if user = user_id && Repo.get(User, user_id) do
          assign(conn, :user, user)
      else
          assign(conn, :user, nil)
      end
    end
  end
end
