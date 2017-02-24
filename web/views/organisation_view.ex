defmodule Flexcility.OrganisationView do
  use Flexcility.Web, :view
  alias Flexcility.Organisation
  import Flexcility.LayoutView, only: [display_name: 1,
                                        display_created_at: 1,
                                        image: 1, thumb: 1]

  def get_members(organisation) do
    Organisation.get_members(organisation)
  end

  def render("subdomain_unique.json", %{subdomain_unique: subdomain_unique}) do
    subdomain_unique
  end
end
