defmodule PtonWeb.AuthControllerTest do
  use PtonWeb.ConnCase
  alias Pton.Repo
  alias Pton.User

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
    assert get_flash(conn, :info) == "Thank you for signing in!"
  end
end
