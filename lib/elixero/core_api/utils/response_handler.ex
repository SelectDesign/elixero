defmodule EliXero.CoreApi.Utils.ResponseHandler do
  def handle_response(response, expected_model) do
    case response do
      %{:status_code => 200} -> transform(response.body, expected_model, :ok)
      %{:status_code => 204} -> %{:status_code => 204, :message => "No Content"}
      %{:status_code => 400} -> transform(response.body, expected_model, :bad_request)
      %{:status_code => 500} -> transform_to_api_exception(response.body)
      _ -> %{:status_code => response.status_code, :message => URI.decode_query(response.body)}
    end
  end

  # Skip the sobelow atom exhaustion check because the response is coming from a successful request to Xero and there
  # are only so many response types it can send.
  # sobelow_skip ["DOS.DecodeAtoms"]
  defp transform(json, module, :ok) do
    case Poison.decode(json, keys: :atoms) do
      {:ok, data} -> module.from_map(data)
      _ -> "Something went wrong transforming to module"
    end
  end

  # Skip the sobelow atom exhaustion check because the response is coming from an error response from Xero and there
  # are only so many response types it can send.
  # sobelow_skip ["DOS.DecodeAtoms"]
  defp transform(json, module, :bad_request) do
    case Poison.decode(json, keys: :atoms) do
      {:ok, %{:ErrorNumber => 10} = data} -> module.from_validation_exception(data)
      {:ok, data} -> data
      _ -> "Something went wrong transforming to module"
    end
  end

  # Skip the sobelow atom exhaustion check because the response is coming from an error response from Xero and there
  # are only so many response types it can send.
  # sobelow_skip ["DOS.DecodeAtoms"]
  defp transform_to_api_exception(json) do
    case Poison.decode(json, keys: :atoms) do
      {:ok, data} -> EliXero.CoreApi.Models.Exceptions.ApiException.from_map(data)
      _ -> "Something went wrong transforming to module"
    end
  end
end
