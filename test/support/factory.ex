defmodule Pton.Factory do
  use ExMachina.Ecto, repo: Pton.Repo

  def user_factory do
    %Pton.Accounts.User{
      token: sequence("token"),
      netid: sequence("batman"),
      provider: "cas",
      links: [],
    }
  end

  def link_factory do
    %Pton.Redirection.Link{
      slug: sequence("slug"),
      url: sequence(:url, &"http://batcave.com/#{&1}"),
      owners: [build(:user)],
      is_safe: true,
    }
  end
end
