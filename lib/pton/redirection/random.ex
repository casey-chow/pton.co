defmodule Pton.Redirection.Random do
	def string(length) do
		alphabet =
      "abcdefghijklmnopqrstuvwxyz"
      <> "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      <> "0123456789"
    alphabet_length = alphabet |> String.length

    1..length
    |> Enum.map_join(fn(_) ->
      String.at(alphabet, :random.uniform(alphabet_length ) - 1)
    end)
 end
end
