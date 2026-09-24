defmodule EliXero.Utils.Helpers do
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def join_params_keyword(keyword, :base_string) do
    Enum.map_join(keyword, "&", fn {key, value} -> param_key_to_string(key) <> "=" <> value end)
  end

  def join_params_keyword(keyword, :auth_header) do
    Enum.map_join(keyword, ", ", fn {key, value} -> param_key_to_string(key) <> "=\"" <> value <> "\"" end)
  end

  defp param_key_to_string(key) when is_atom(key), do: Atom.to_string(key)
  defp param_key_to_string(key) when is_binary(key), do: key
end
