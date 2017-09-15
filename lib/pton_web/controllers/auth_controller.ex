defmodule PtonWeb.AuthController do
  use PtonWeb, :controller
  plug Ueberauth

  alias Pton.Repo
  alias Pton.Accounts.User

  def new(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      netid: auth.info.email, 
      provider: "cas",
    }
    changeset = User.changeset(%User{}, user_params)
    
    create(conn, changeset)
  end

  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: page_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, netid: changeset.changes.netid) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
end
