defmodule EliXero do
  def get_request_token do
    response =
      case(Application.get_env(:elixero, :app_type)) do
        :private -> raise "Getting a request token is not applicable with Private applications."
      end

    case response do
      %{"http_status_code" => 200}  -> Map.merge(response, %{"auth_url" => EliXero.Utils.Urls.authorise(response["oauth_token"])})
      _                             -> response
    end
  end

  def create_client(access_token, tenant_id) do
    %EliXero.Client{app_type: :private, access_token: access_token, tenant_id: tenant_id}
  end
end
