defmodule EliXero.Private do

  def find(client, resource, api_type) do
    url = EliXero.Utils.Urls.api(resource, api_type)

    header = "Bearer " <> client.access_token
    EliXero.Utils.Http.get(url, header, client.tenant_id)
  end

  def find(client, resource, api_type, query_filters, extra_headers) do
    url = EliXero.Utils.Urls.api(resource, api_type) |> EliXero.Utils.Urls.append_query_filters(query_filters)

    header = "Bearer " <> client.access_token
    EliXero.Utils.Http.get(url, header, client.tenant_id, extra_headers)
  end

  def create(client, resource, api_type, data_map) do
    url = EliXero.Utils.Urls.api(resource, api_type)

    method =
      case(api_type) do
        :core -> "PUT"
      end

    header = "Bearer " <> client.access_token
    case(method) do
      "PUT" -> EliXero.Utils.Http.put(url, header, client.tenant_id, data_map)
    end
  end

  def update(client, resource, api_type, data_map) do
    url = EliXero.Utils.Urls.api(resource, api_type)

    method =
      case(api_type) do
        :core -> "POST"
      end

    header = "Bearer " <> client.access_token
    case(method) do
      "POST" -> EliXero.Utils.Http.post(url, header, client.tenant_id, data_map)
    end
  end

  def delete(client, resource, api_type) do
    url = EliXero.Utils.Urls.api(resource, api_type)

    header = "Bearer " <> client.access_token

    EliXero.Utils.Http.delete(url, header)
  end

  def upload_multipart(client, resource, api_type, path_to_file, name) do
    url = EliXero.Utils.Urls.api(resource, api_type)

    header = "Bearer " <> client.access_token

    EliXero.Utils.Http.post_multipart(url, header, client.tenant_id, path_to_file, name)
  end

  def upload_attachment(client, resource, api_type, path_to_file, filename, include_online) do
    url = EliXero.Utils.Urls.api(resource, api_type)
    url_for_signing = url <> "/" <> String.replace(filename, " ", "%20") <> "?includeonline=" <> ( if include_online, do: "true", else: "false") # Spaces must be %20 not +
    header = "Bearer " <> client.access_token

    url = url <> "/" <> URI.encode(filename, &URI.char_unreserved?(&1)) <> "?includeonline=" <> ( if include_online, do: "true", else: "false")
    EliXero.Utils.Http.post_file(url, header, client.tenant_id, path_to_file)
  end
end
