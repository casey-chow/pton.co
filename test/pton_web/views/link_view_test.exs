defmodule PtonWeb.LinkViewTest do
  use PtonWeb.ConnCase, async: true

  alias PtonWeb.LinkView

  describe "enumerate_list" do
    test "enumerates one item" do
      assert LinkView.enumerate_list(["test"]) == "test"
    end

    test "enumerates two items" do
      assert LinkView.enumerate_list(["test", "something"]) ==
        "test and something"
    end

    test "enumerates three items" do
      assert LinkView.enumerate_list(["test", "something", "else"]) ==
        "test, something, and else"
    end

    test "enumerates more than three items" do
      assert LinkView.enumerate_list(["test", "something", "else", "entirely"]) ==
        "test, something, else, and entirely"
    end
  end
end
