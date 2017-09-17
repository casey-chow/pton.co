defmodule PtonWeb.PageControllerTest do
  use PtonWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "pton.co"
  end

  test "shows a sign in link when not signed in", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Sign in"
  end

  test "shows a sign out link when signed in", %{conn: conn} do
    user = insert(:user)

    conn = conn
    |> assign(:user, user)
    |> get("/")

    assert html_response(conn, 200) =~ "Sign out"
  end
end
