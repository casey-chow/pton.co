# http://blog.danielberkompas.com/elixir/2015/06/16/rate-limiting-a-phoenix-api.html
defmodule PtonWeb.Plugs.RateLimit do
  import Phoenix.Controller
  import Plug.Conn

  def rate_limit(conn, options \\ []) do
    case check_rate(conn, options) do
      {:ok, _count}   -> conn # Do nothing, pass on to the next plug
      {:fail, _count} -> render_error(conn)
    end
  end

  def rate_limit_authentication(conn, options \\ []) do
    options = Map.merge(options, %{bucket_name: "authorization:" <> conn.assigns.user.netid})
    rate_limit(conn, options)
  end

  defp check_rate(conn, options) do
    interval_milliseconds = options[:interval_seconds] * 1000
    max_requests = options[:max_requests]
    bucket_name = options[:bucket_name] || bucket_name(conn)

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
    |> put_status(:forbidden)
    |> json(%{error: "Rate limit exceeded."})
    |> halt # Stop execution of further plugs, return response now
  end
end
