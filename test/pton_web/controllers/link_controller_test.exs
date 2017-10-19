defmodule PtonWeb.LinkControllerTest do
  use PtonWeb.ConnCase

  alias Pton.Redirection
  alias Pton.Accounts
  alias Pton.Repo

  @create_attrs %{slug: "some-slug", url: "http://google.com"}
  @update_attrs %{slug: "some-updated-slug", url: "http://yahoo.com"}
  @invalid_attrs %{slug: nil, url: nil}

  describe "index" do
    setup [:create_link]

    test "lists all links", %{conn: conn, link: link} do
      conn = get conn, link_path(conn, :index)
      assert html_response(conn, 200) =~ "All Links"
      assert html_response(conn, 200) =~ link.slug
    end
  end

  describe "my links" do
    setup [:create_link_with_owner]

    test "lists only links owned by the current user", %{conn: conn, link: link, user: user} do
      other_link = insert(:link)
      conn = conn
      |> assign(:user, user)
      |> get(link_path(conn, :mine))

      assert html_response(conn, 200) =~ "My Links"
      assert html_response(conn, 200) =~ link.slug
      assert not(html_response(conn, 200) =~ other_link.slug)
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

    test "renders login button if user not logged in", %{conn: conn} do
      conn = conn
      |> get(link_path(conn, :new))

      assert not(html_response(conn, 200) =~ "enter a url")
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

      conn = get conn, link_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Link"
    end

    test "does not create link without url", %{conn: conn, user: user} do
      conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: Map.delete(@create_attrs, :url))

      assert length(Redirection.list_links) == 0
    end

    test "creates a random slug when no slug exists", %{conn: conn, user: user} do
      conn = conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: Map.delete(@create_attrs, :slug))

      %{id: id} = redirected_params(conn)

      link = Redirection.get_link!(id)
      assert not(is_nil(link.slug))
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

    test "validates urls on creation", %{conn: conn, user: user} do
      conn = conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: %{@create_attrs | url: "http://'; DROP TABLE links;.com"})

      assert html_response(conn, 200) =~ "New Link"
    end

    test "prevents creation of links to self", %{conn: conn, user: user} do
      host = Application.get_env(:pton, PtonWeb.Endpoint)[:url][:host]

      conn = conn
      |> assign(:user, user)
      |> post(link_path(conn, :create), link: %{@create_attrs | url: "https://#{host}/asdf"})

      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "show link" do
    setup [:create_link_with_owner]

    test "shows edit button if user owns link", %{conn: conn, user: user, link: link} do
      conn = conn
      |> assign(:user, user)
      |> get(link_path(conn, :show, link))

      assert html_response(conn, 200) =~ "Edit Link"
    end

    test "hides edit button if user does not own link", %{conn: conn, link: link} do
      user = insert(:user)

      conn = conn
      |> assign(:user, user)
      |> get(link_path(conn, :show, link))

      assert not(html_response(conn, 200) =~ "Edit Link")
    end

    test "shows owner if user is logged in", %{conn: conn, link: link} do
      user = insert(:user)

      conn = conn
      |> assign(:user, user)
      |> get(link_path(conn, :show, link))

      assert html_response(conn, 200) =~ user.netid
    end

    test "hides owner if user is not logged in", %{conn: conn, link: link, user: user} do
      conn = conn |> get(link_path(conn, :show, link))

      assert not(html_response(conn, 200) =~ user.netid)
    end
  end

  describe "edit link" do
    setup [:create_link_with_owner]

    test "renders form for editing chosen link", %{conn: conn, user: user, link: link} do
      conn =  conn
      |> assign(:user, user)
      |> get(link_path(conn, :edit, link))

      assert html_response(conn, 200) =~ "Edit Link"
    end
  end

  describe "follow link" do
    setup [:create_link]

    test "redirects to destination", %{conn: conn, link: link} do
      conn = get conn, link_path(conn, :follow, link.slug)
      assert redirected_to(conn) == link.url
    end
  end

  describe "update link" do
    setup [:create_link_with_owner]

    test "redirects when data is valid", %{conn: conn, link: link, user: user} do
      conn = conn
      |> assign(:user, user)
      |> put(link_path(conn, :update, link), link: @update_attrs)

      assert redirected_to(conn) == link_path(conn, :show, link)

      conn = get conn, link_path(conn, :show, link)
      assert html_response(conn, 200) =~ "some-updated-slug"
    end

    test "renders errors when data is invalid", %{conn: conn, link: link, user: user} do
      conn = conn
      |> assign(:user, user)
      |> put(link_path(conn, :update, link), link: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Link"
    end

    test "validates that the user is an owner before updating", %{conn: conn, link: link, user: user} do
      other_user = insert(:user)
      assert other_user.id != user.id

      conn = conn
      |> assign(:user, other_user)
      |> put(link_path(conn, :update, link), link: @update_attrs)

      assert get_flash(conn, :error) =~ "not authorized"
    end

    test "validates urls on update", %{conn: conn, link: link, user: user} do
      conn = conn
      |> assign(:user, user)
      |> put(link_path(conn, :update, link), link: %{url: "http://'; DROP TABLE links;.com"})

      assert html_response(conn, 200) =~ "Edit Link"
    end
  end

  describe "delete link" do
    setup [:create_link_with_owner]

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

    test "validates that the user is an owner before deleting", %{conn: conn, link: link, user: user} do
      num_links = length(Redirection.list_links())
      other_user = insert(:user)
      assert other_user.id != user.id

      conn = conn
      |> assign(:user, other_user)
      |> delete(link_path(conn, :delete, link))

      assert get_flash(conn, :error) =~ "not authorized"
      assert length(Redirection.list_links()) == num_links
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

  defp create_link_with_owner(_) do
    user = insert(:user)
    link = insert(:link, owners: [user])
    {:ok, user: user, link: link}
  end

end
