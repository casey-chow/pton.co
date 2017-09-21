defmodule PtonWeb.Plugs.RateLimitTest do
  use PtonWeb.ConnCase

  alias PtonWeb.Plugs.RateLimit

  describe "rate limiting with authentication" do
    test "allows requests through if within limits", %{conn: conn} do
      conn = conn
      |> RateLimit.rate_limit(max_requests: 9, interval_seconds: 10000)

      assert conn.status != 429
    end

    test "blocks requests if exceeds limits", %{conn: conn} do
      conn |> RateLimit.rate_limit(max_requests: 1, interval_seconds: 10000)
      conn = conn |> RateLimit.rate_limit(max_requests: 1, interval_seconds: 10000)

      assert conn.status == 429
    end

    test "recognizes and buckets off of user if logged in", %{conn: conn} do
      user = build(:user)

      conn
      |> assign(:user, user)
      |> RateLimit.rate_limit_authentication(max_requests: 1, interval_seconds: 10000)

      conn = conn
      |> assign(:user, user)
      |> RateLimit.rate_limit_authentication(max_requests: 1, interval_seconds: 10000)

      assert conn.status == 429
    end
  end
end
