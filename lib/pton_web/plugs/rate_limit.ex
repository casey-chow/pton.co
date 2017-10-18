defmodule PtonWeb.Plugs.RateLimit do
  @moduledoc """
  This plug enables rate limiting of the backend API, to prevent abuse.
  http://blog.danielberkompas.com/elixir/2015/06/16/rate-limiting-a-phoenix-api.html
  """
  import Phoenix.Controller, only: [render: 3]
  import Plug.Conn

  def rate_limit(conn, options \\ []) do
    options = Enum.into(options, %{})
    case check_rate(conn, options) do
      {:ok, _count}   -> conn # do nothing
      {:error, _count} -> render_error(conn)
    end
  end

  def rate_limit_authentication(conn, options \\ []) do
    options = Keyword.put(options, :bucket_name, "authorization:" <> conn.assigns.user.netid)
    rate_limit(conn, options)
  end

  defp check_rate(conn, options) do
    interval_milliseconds = options[:interval_seconds] * 1000
    max_requests = options[:max_requests]
    bucket_name = Map.get(options, :bucket_name, bucket_name(conn))

    ExRated.check_rate(bucket_name, interval_milliseconds, max_requests)
  end

  # Bucket name should be a combination of ip address and request path, like so:
  #
  # "127.0.0.1:/api/v1/authorizations"
  defp bucket_name(conn) do
    path = Enum.join(conn.path_info, "/")
    ip   = conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    "#{ip}:#{path}"
  end

  defp render_error(conn) do
    conn
    |> put_status(:too_many_requests)
    |> render(PtonWeb.ErrorView, "429.html")
    |> halt
  end
end
