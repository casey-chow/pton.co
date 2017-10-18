defmodule PtonWeb.LinkView do
  use PtonWeb, :view

  import Pton.Redirection, only: [is_owner?: 2]

  def list_owners(link) do
    link.owners
    |> Enum.map(&(&1.netid))
    |> enumerate_list
  end

  def canonical_link_url(link) do
    "pton.co/" <> link.slug
  end

  def canonical_link_url(:full, link) do
    "https://pton.co/" <> link.slug
  end

  def enumerate_list([a]),       do: a
  def enumerate_list([a, b]),    do: a <> " and " <> b
  def enumerate_list([a, b, c]), do: a <> ", " <> b <> ", and " <> c
  def enumerate_list([head | tail]) when length(tail) > 2 do
    head <> ", " <> enumerate_list(tail)
  end
end
