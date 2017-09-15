defmodule Pton.RedirectionTest do
  use Pton.DataCase

  alias Pton.Redirection

  describe "links" do
    alias Pton.Redirection.Link

    @valid_attrs %{slug: "some slug", url: "some url"}
    @update_attrs %{slug: "some updated slug", url: "some updated url"}
    @invalid_attrs %{slug: nil, url: nil}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Redirection.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Redirection.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Redirection.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Redirection.create_link(@valid_attrs)
      assert link.slug == "some slug"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Redirection.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, link} = Redirection.update_link(link, @update_attrs)
      assert %Link{} = link
      assert link.slug == "some updated slug"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Redirection.update_link(link, @invalid_attrs)
      assert link == Redirection.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Redirection.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Redirection.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Redirection.change_link(link)
    end
  end
end
