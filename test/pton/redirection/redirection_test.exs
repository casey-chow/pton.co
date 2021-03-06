defmodule Pton.RedirectionTest do
  use Pton.DataCase

  alias Pton.Redirection

  describe "links" do
    alias Pton.Redirection.Link

    @valid_attrs %{"slug" => "some_slug", "url" => "http://google.com/"}
    @update_attrs %{"slug" => "some_updated_slug", "url" => "http://yahoo.com/"}
    @invalid_attrs %{"slug" => "invalidslug!!!", "url" => "asldifhwoie"}

    setup [:create_user]

    test "list_links/0 returns all links" do
      link = insert(:link)
      links = Redirection.list_links()

      assert length(links) == 1
      assert Enum.fetch!(links, 0).id == link.id
    end

    test "user_links/1 returns only links owned by user" do
      user = insert(:user)
      link = insert(:link, owners: [user])
      _other_link = insert(:link)

      links = Redirection.user_links(user)

      assert length(links) == 1
      assert Enum.fetch!(links, 0).id == link.id
    end

    test "user_links/1 returns the number of links owned by user" do
      user = insert(:user)
      _links = insert_list(5, :link, owners: [user])
      _other_link = insert(:link)

      assert Redirection.count_user_links(user) == 5
    end

    test "get_link!/1 returns the link with given id" do
      link = insert(:link)
      retrieved_link = Redirection.get_link!(link.id) |> Repo.preload(:owners)

      assert retrieved_link.id == link.id
    end

    test "create_link/2 with valid data creates a link", %{user: user} do
      assert {:ok, %Link{} = link} = Redirection.create_link(user, @valid_attrs)
      assert link.slug == "some_slug"
      assert link.url == "http://google.com/"
    end

    test "create_link/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Redirection.create_link(user, @invalid_attrs)
    end

    test "create_link/2 with duplicate data returns error changeset", %{user: user} do
      assert {:ok, %Link{}} = Redirection.create_link(user, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Redirection.create_link(user, @valid_attrs)
    end

    test "create_link/2 with a user who has reached their quota returns an error changeset", %{user: user} do
      insert_list(Application.fetch_env!(:pton, :max_lifetime_links), :link, owners: [user])

      assert_raise Pton.QuotaExceededError, fn -> Redirection.create_link(user, @valid_attrs) end
    end

    test "update_link/2 with valid data updates the link" do
      link = insert(:link)
      assert {:ok, link} = Redirection.update_link(link, @update_attrs)
      assert %Link{} = link
      assert link.slug == "some_updated_slug"
      assert link.url == "http://yahoo.com/"
    end

    test "update_link/1 with invalid data returns error changeset" do
      link = insert(:link)
      assert {:error, %Ecto.Changeset{}} = Redirection.update_link(link, @invalid_attrs)
      new_link = Redirection.get_link!(link.id)

      assert new_link.slug == link.slug
      assert new_link.url == link.url
    end

    test "delete_link/1 deletes the link" do
      link = insert(:link)
      assert {:ok, %Link{}} = Redirection.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Redirection.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = insert(:link)
      assert %Ecto.Changeset{} = Redirection.change_link(link)
    end

    defp create_user(_) do
      user = insert(:user)
      {:ok, user: user}
    end
  end
end
