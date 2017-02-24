defmodule Flexcility.Subdomain.DashboardController do
  use Flexcility.Web, :controller
  alias Flexcility.Router
  alias Flexcility.Organisation

  def index(conn, _params) do
    render(conn, "index.html", organisations: Repo.all(Organisation))
  end
end
