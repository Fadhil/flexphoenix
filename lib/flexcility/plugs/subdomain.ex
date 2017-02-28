defmodule Flexcility.Plug.Subdomain do
  import Plug.Conn
  alias Flexcility.Repo
  alias Flexcility.Organisation

  @doc false
  def init(default), do: default

  @doc false
  def call(conn, router) do
    case get_subdomain(conn.host) do
      subdomain when byte_size(subdomain) > 0 ->
        case verify_subdomain(subdomain) do
          true ->
            conn
            |> fetch_session
            |> put_private(:subdomain, subdomain)
            |> router.call(router.init({}))
            |> halt
          false ->
            conn
            |> Phoenix.Controller.redirect(external: Flexcility.Router.Helpers.page_url(conn, :subdomain_not_found))
            |> halt

        end
      _ -> conn
    end
  end

  defp get_subdomain(host) do
    root_host = Flexcility.Endpoint.config(:url)[:host]
    String.replace(host, ~r/.?#{root_host}/, "")
  end

  defp verify_subdomain(subdomain) do
    case Repo.get_by(Organisation, subdomain: subdomain) do
      nil ->
        false
      %{subdomain: ^subdomain} ->
        true
      _ ->
        false
    end
  end
end
