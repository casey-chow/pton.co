defmodule PtonWeb.Helpers do
  @moduledoc """
  Useful general helpers.
  """

  use Phoenix.HTML

  def enumerate_list([item]) do
    item
  end

  def enumerate_list([item1, item2]) do
    item1 <> " and " <> item2
  end

  def enumerate_list([item1, item2, item3]) do
    item1 <> ", " <> item2 <> ", and" <> item3
  end

  def enumerate_list([head | tail]) when length(tail) > 2 do
    head <> ", " <> enumerate_list(tail)
  end
end
