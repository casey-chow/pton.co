defmodule Pton.AccountsTest do
  use Pton.DataCase

  alias Pton.Accounts

  describe "users" do
    alias Pton.Accounts.User

    @valid_attrs %{netid: "batman", provider: "cas", token: "fowi3o2323f23"}
    @update_attrs %{netid: "batman2", provider: "google", token: "3i2392f03j23l"}
    @invalid_attrs %{netid: nil, provider: nil, token: nil}

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      retrieved_user = Accounts.get_user!(user.id) |> Repo.preload(:links)

      assert retrieved_user == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.netid == "batman"
      assert user.provider == "cas"
      assert user.token == "fowi3o2323f23"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.netid == "batman2"
      assert user.provider == "google"
      assert user.token == "3i2392f03j23l"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)

      new_user = Accounts.get_user!(user.id)
      assert new_user.netid == user.netid
      assert new_user.provider == user.provider
      assert new_user.token == user.token
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
