defmodule HelpersTest do
  use ExUnit.Case

  alias EliXero.Utils.Helpers

  test "base string parameters accept atom and string keys without creating atoms" do
    params = [{:oauth_version, "1.0"}, {:where, "Status"}, {"page", "2"}]

    assert Helpers.join_params_keyword(params, :base_string) == "oauth_version=1.0&where=Status&page=2"
  end
end
