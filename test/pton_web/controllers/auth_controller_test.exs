defmodule PtonWeb.AuthControllerTest do
  use PtonWeb.ConnCase

  alias Pton.Repo
  alias Pton.Accounts.User

  # mock response from CAS
  # TODO(casey-chow): verify format of response
  @ueberauth_auth %{credentials: %{token: "fdsnoafhnoofh08h38h"},
                    info: %{email: "christophereisgruber"},
                    provider: :cas}

  test "redirects user to CAS for authentication", %{conn: conn} do
    conn = get conn, "/auth/cas"
    assert redirected_to(conn, 302)
  end

  test "creates user from CAS", %{conn: conn} do
    conn = conn
    |> assign(:ueberauth_auth, @ueberauth_auth)
    |> get("/auth/cas/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
  end

  test "signs out user", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/auth/signout")
    |> get("/")

    assert conn.assigns.user == nil
  end
end
