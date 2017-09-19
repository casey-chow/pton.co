defmodule PtonWeb.PageController do
  use PtonWeb, :controller

  alias Pton.Redirection
  alias Pton.Redirection.Link

  def index(conn, _params) do
    changeset = Redirection.change_link(%Link{})
    render(conn, "index.html", changeset: changeset)
  end

  def kitchen_sink(conn, _params) do
    render conn, "kitchen_sink.html"
  end
end
