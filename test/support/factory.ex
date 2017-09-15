defmodule Pton.Factory do
  use ExMachina.Ecto, repo: Pton.Repo

  def user_factory do
    %Pton.User{
      token: "ffnebyt73bich9",
      netid: "batman",
      provider: "cas",
    }
  end
end
