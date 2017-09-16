defmodule Pton.RedirectionTest do
  use Pton.DataCase

  alias Pton.Redirection

  describe "links" do
    alias Pton.Redirection.Link

    @valid_attrs %{slug: "some slug", url: "some url"}
    @update_attrs %{slug: "some updated slug", url: "some updated url"}
    @invalid_attrs %{slug: nil, url: nil}

    setup [:create_user]

    test "list_links/0 returns all links" do
      link = insert(:link)
      assert Redirection.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = insert(:link)
      retrieved_link = Redirection.get_link!(link.id) |> Repo.preload(:owners)

      assert retrieved_link == link
    end

    test "create_link/1 with valid data creates a link", %{user: user} do
      assert {:ok, %Link{} = link} = Redirection.create_link(user, @valid_attrs)
      assert link.slug == "some slug"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Redirection.create_link(user, @invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = insert(:link)
      assert {:ok, link} = Redirection.update_link(link, @update_attrs)
      assert %Link{} = link
      assert link.slug == "some updated slug"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = insert(:link)
      assert {:error, %Ecto.Changeset{}} = Redirection.update_link(link, @invalid_attrs)
      assert link == Redirection.get_link!(link.id)
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
