defmodule Pton.QuotaExceededError do
  @moduledoc """
  Raised when the user exceeds a given resource quota.
  This exception is raised by `Pton.Redirection.create_link/2`.
  """

  defexception [:message, plug_status: 429]

  def exception do
    msg = "The current user has exceeded their hard quota for the number " <>
          "of links created in their lifetime. Try deleting some links or " <>
          "contacting the administrator of this site."
    %Phoenix.MissingParamError{message: msg}
  end
end
