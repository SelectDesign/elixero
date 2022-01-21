defmodule EliXero.Utils.Http do

  @accept "application/json"

  @connection_timeout 330000

  def options() do
    [recv_timeout: @connection_timeout]
  end

  def headers(authorisation_header, tenant_id) do
    [{"Authorization", authorisation_header}, {"Accept", @accept}, {"Xero-tenant-id", tenant_id}]
  end

  def get(url, authorisation_header, tenant_id) do
    {:ok, response} = HTTPoison.get url, headers(authorisation_header, tenant_id), options() # ++ [{:proxy, "127.0.0.1:8888"}]

    response
  end

  def get(url, authorisation_header, tenant_id, extra_headers) do
    headers = headers(authorisation_header, tenant_id) ++ extra_headers

    {:ok, response} = HTTPoison.get url, headers, options() # ++ [{:proxy, "127.0.0.1:8888"}]

    response
  end

  def put(url, authorisation_header, tenant_id, data_map) do
    {_, payload} = Poison.encode(data_map)

    {:ok, response} = HTTPoison.put url, payload, headers(authorisation_header, tenant_id), options() # ++ [{:proxy, "127.0.0.1:8888"}]

    response
  end

  def post(url, authorisation_header, tenant_id, data_map) do
    {_, payload} = Poison.encode(data_map)

    {:ok, response} = HTTPoison.post url, payload, headers(authorisation_header, tenant_id), options() # ++ [{:proxy, "127.0.0.1:8888"}]

    response
  end

  def delete(url, authorisation_header, tenant_id) do
    {:ok, response} = HTTPoison.delete url, headers(authorisation_header, tenant_id), options() # ++ [{:proxy, "127.0.0.1:8888"}]

    response
  end

  def post_multipart(url, authorisation_header, tenant_id, path_to_file, name) do
    # The Xero Files API grabs the filename out of the content-disposition header of the multipart file request.
    # Hackney sets this to be the filename from the path of the file. We need to override it
    content_disposition_overload = "form-data; filename=\"" <> name <> "\""

    {:ok, response} = HTTPoison.post url, {:multipart, [{:file, path_to_file, [{"Content-Disposition", content_disposition_overload}]}]}, headers(authorisation_header, tenant_id), options() # ++ [{:proxy, "127.0.0.1:8888"}]

    handle_response(response)
  end

  def post_file(url, authorisation_header, tenant_id, path_to_file) do
    {:ok, response} = HTTPoison.post url, {:file, path_to_file}, headers(authorisation_header, tenant_id), options() # ++ [{:proxy, "127.0.0.1:8888"}]

    response
  end

  # possibly used by files beta. CoreAPI does not use after including Ecto.Schema
  defp handle_response(response) do

    headers = response.headers |> Map.new
    content_type = headers["Content-Type"]

    case content_type do
      nil -> handle_html_response(response)
      _ -> handle_response(response, content_type)
    end
  end

  # possibly used by files beta. CoreAPI does not use after including Ecto.Schema
  defp handle_response(response, content_type) do
    content_type = String.split(content_type, " ") |> Enum.at(0)

    case content_type do
      "application/json;" -> handle_json_response(response)
      _ -> handle_html_response(response)
    end
  end

  # possibly used by files beta. CoreAPI does not use after including Ecto.Schema
  defp handle_json_response(response) do
    resp = %{"http_status_code" => response.status_code}

    {_, parsed} = Poison.Parser.parse(response.body)
    Map.merge(resp, parsed)
  end

  # possibly used by files beta. CoreAPI does not use after including Ecto.Schema
  defp handle_html_response(response) do
    resp = %{"http_status_code" => response.status_code}
    URI.decode_query(response.body) |> Map.merge(resp)
  end
end
