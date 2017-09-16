defmodule PtonWeb.LinkControllerTest do
  use PtonWeb.ConnCase

  alias Pton.Redirection
  alias Pton.Accounts
  alias Pton.Repo

  @create_attrs %{slug: "some slug", url: "some url"}
  @update_attrs %{slug: "some updated slug", url: "some updated url"}
  @invalid_attrs %{slug: nil, url: nil}

  describe "index" do
    test "lists all links", %{conn: conn} do
      conn = get conn, link_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Links"
    end
  end

  describe "new link" do
    setup [:create_user]

    test "renders form", %{conn: conn, user: user} do
      conn = conn
      |> assign(:user, user)
      |> get(link_path(conn, :new))

      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "create link" do
    setup [:create_user]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == link_path(conn, :show, id)


      conn = conn |> get(link_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Link"
    end

    test "includes current user as owner on creation", %{conn: conn, user: user} do
      conn =  conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: @create_attrs)

      %{id: id} = redirected_params(conn)

      link = Redirection.get_link!(id)
      users = Repo.all(Ecto.assoc(link, :owners))

      assert length(users) == 1
      assert Enum.fetch!(users, 0).id == user.id
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "edit link" do
    setup [:create_user, :create_link]

    test "renders form for editing chosen link", %{conn: conn, user: user, link: link} do
      conn =  conn
      |> assign(:user, user)
      |> get(link_path(conn, :edit, link))

      assert html_response(conn, 200) =~ "Edit Link"
    end
  end

  describe "update link" do
    setup [:create_user, :create_link]

    test "redirects when data is valid", %{conn: conn, link: link, user: user} do
      conn = conn
      |> assign(:user, user)
      |> put(link_path(conn, :update, link), link: @update_attrs)

      assert redirected_to(conn) == link_path(conn, :show, link)

      conn = get conn, link_path(conn, :show, link)
      assert html_response(conn, 200) =~ "some updated slug"
    end

    test "renders errors when data is invalid", %{conn: conn, link: link, user: user} do
      conn = conn
      |> assign(:user, user)
      |> put(link_path(conn, :update, link), link: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Link"
    end
  end

  describe "delete link" do
    setup [:create_user, :create_link]

    test "deletes chosen link", %{conn: conn, link: link, user: user} do
      conn = conn
      |> assign(:user, user)
      |> delete(link_path(conn, :delete, link))
      assert redirected_to(conn) == link_path(conn, :index)

      assert_error_sent 404, fn ->
        conn
        |> assign(:user, user)
        |> get(link_path(conn, :show, link))
      end
    end

    test "deletes only the corresponding link", %{conn: conn, link: link, user: user} do
      insert_list(2, :link, %{ owners: [user] })
      num_users = length(Accounts.list_users())

      conn
      |> assign(:user, user)
      |> delete(link_path(conn, :delete, link))

      assert length(Accounts.list_users()) == num_users
      assert length(Redirection.list_links()) == 2
    end
  end

  defp create_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end

  defp create_link(_) do
    link = insert(:link)
    {:ok, link: link}
  end
end
