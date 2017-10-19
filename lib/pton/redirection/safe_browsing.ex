defmodule Pton.Redirection.SafeBrowsing do
  @moduledoc """
  Interface for the Google Safe Browsing Lookup API, to allow
  clients to determine whether URLs are safe.
  """

  @endpoint "https://safebrowsing.googleapis.com/v4/threatMatches:find"

  # https://stackoverflow.com/a/35704257
  @client_version Mix.Project.config[:version]

  @doc """
  Returns true iff the site requested is deemed safe by Google's Safe Browsing
  API. Returns false otherwise.
  """
  def is_safe?(url) do
    %{body: body} = HTTPoison.post!(endpoint(), body_request_for(url),
                                   [{"Accept", "application/json"}])

    body
    |> Poison.Parser.parse!
    |> :erlang.==(%{})
  end

  defp endpoint do
    api_key = Application.get_env(:pton, PtonWeb.Endpoint)[:google_api_key]
    @endpoint <> "?key=" <> api_key
  end

  defp body_request_for(url) do
    Poison.encode!(%{
      "client" => %{
        "clientId" => "pton-co",
        "clientVersion" => "0.0.1"
      },
      "threatInfo" => %{
        "threatTypes" => [
          "MALWARE",
          "POTENTIALLY_HARMFUL_APPLICATION",
          "SOCIAL_ENGINEERING"
        ],
        "platformTypes" => ["ANY_PLATFORM"],
        "threatEntryTypes" => ["URL"],
        "threatEntries" => [%{"url" => url}]
      }
    })
  end
end
