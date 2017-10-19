defmodule Pton.Redirection.SafeBrowsingTest do
  use Pton.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Pton.Redirection.SafeBrowsing

  describe "is_safe?" do
    setup do
      ExVCR.Config.filter_sensitive_data("key=.*", "key=GOOGLE_API_KEY")
      :ok
    end

    test "returns true if api returns no security report" do
      use_cassette "site_is_safe" do
        assert SafeBrowsing.is_safe? "http://google.com/"
      end
    end

    test "returns false for empty string" do
      use_cassette "site_is_not_safe", custom: true do
        assert not SafeBrowsing.is_safe? ""
      end
    end

    test "returns false if api returns a security warning" do
      use_cassette "site_is_not_safe", custom: true do
        assert not SafeBrowsing.is_safe? "http://google.com/"
      end
    end
  end
end
