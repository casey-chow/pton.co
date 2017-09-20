defmodule PtonWeb.LinkController do
  use PtonWeb, :controller

  plug :authenticate when action in [:create, :edit, :update, :delete]
  plug :check_owner when action in [:edit, :update, :delete]

  alias Pton.Redirection
  alias Pton.Redirection.Link

  def index(conn, _params) do
    links = Redirection.list_links()
    render(conn, "index.html", links: links)
  end

  def new(conn, _params) do
    changeset = Redirection.change_link(%Link{})
    conn
    |> assign(:hide_site_name, true)
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    case Redirection.create_link(conn.assigns.user, link_params) do
      {:ok, link} ->
        conn
        |> put_flash(:success, "Link created successfully.")
        |> redirect(to: link_path(conn, :show, link))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Redirection.get_link!(id)
    render(conn, "show.html", link: link)
  end

  def follow(conn, %{"slug" => slug}) do
    link = Redirection.get_link_by!(slug: slug)
    redirect conn, external: link.url
  end

  def edit(conn, %{"id" => id}) do
    link = Redirection.get_link!(id)
    changeset = Redirection.change_link(link)
    render(conn, "edit.html", link: link, changeset: changeset)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Redirection.get_link!(id)

    case Redirection.update_link(link, link_params) do
      {:ok, link} ->
        conn
        |> put_flash(:success, "Link updated successfully.")
        |> redirect(to: link_path(conn, :show, link))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", link: link, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Redirection.get_link!(id)
    {:ok, _link} = Redirection.delete_link(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: link_path(conn, :index))
  end

  def authenticate(conn, _) do
    if conn.assigns.user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to do that.")
      |> redirect(to: auth_path(conn, :request, "cas"))
      |> halt()
    end
  end

  def check_owner(conn, _) do
    id = conn.params["id"]
    link = Redirection.get_link! id

    if Redirection.is_owner?(conn.assigns.user, link) do
      conn
    else
      conn
      |> put_status(403)
      |> put_flash(:error, "You are not authorized to modify this link.")
      |> render("show.html", link: link)
      |> halt()
    end
  end
end
