defmodule PtonWeb.PageController do
  use PtonWeb, :controller

  def kitchen_sink(conn, _params) do
    render conn, "kitchen_sink.html"
  end
end
