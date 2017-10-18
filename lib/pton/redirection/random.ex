defmodule Pton.Redirection.Random do
  @moduledoc """
  Module that generates a random alphanumeric string with the given length.
  https://github.com/gutschilla/elixir-helper-random/blob/master/lib/random.ex
  """

  def string(length) do
    alphabet =
      "abcdefghijklmnopqrstuvwxyz"
      <> "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      <> "0123456789"
    alphabet_length = alphabet |> String.length

    1..length
    |> Enum.map_join(fn(_) ->
      String.at(alphabet, :rand.uniform(alphabet_length) - 1)
    end)
 end
end
