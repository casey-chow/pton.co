defmodule PtonWeb.LinkView do
  use PtonWeb, :view

  import PtonWeb.Helpers
  import Pton.Redirection, only: [ is_owner?: 2 ]

  def list_owners(link) do
    link.owners
    |> Enum.map(&(&1.netid))
    |> enumerate_list
  end
end
