defmodule Pton.Redirection.RandomTest do
  use Pton.DataCase

  alias Pton.Redirection.Random

  describe "string" do
    test "generates a random string of appropriate length" do
      assert String.length(Random.string(13)) == 13
    end

    test "generates unique random strings" do
      assert Random.string(10) != Random.string(10)
    end

    test "generates only an alphanumeric sequence" do
      assert Regex.match?(~r/^[a-zA-Z0-9]+$/, Random.string(12))
    end
  end
end
