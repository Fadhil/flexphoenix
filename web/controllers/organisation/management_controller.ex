defmodule Flexcility.Organisation.ManagementController do
  use Flexcility.Web, :controller

  alias Flexcility.Organisation

  def index(conn, %{"organisation_id" => id}) do
    organisation = Repo.get(Organisation, id)
    conn
    |> assign(:page_title, "Manage Organisation")
    |> render("index.html", organisation: organisation)
  end

  def members(conn, %{"organisation_id" => id}) do
    conn
    |> assign(:page_title, "Manage Members")
    |> render("members.html")
  end
end
