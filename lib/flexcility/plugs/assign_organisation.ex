defmodule Flexcility.Plugs.AssignOrganisation do
  import Plug.Conn
  alias Flexcility.Repo
  alias Flexcility.Organisation
  require IEx

  def init(defaults), do: defaults

  def call(conn, _) do
    %{params: %{"organisation_id" => organisation_id}} = fetch_query_params(conn)
    conn
      |> assign(:organisation, Repo.get(Organisation, organisation_id ))
  end
end
