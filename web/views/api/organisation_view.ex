defmodule Flexcility.Api.OrganisationView do
  use Flexcility.Web, :view

  def render("show.json", %{organisation: organisation}) do
    %{
      success: true,
      data: render_one(organisation, Flexcility.Api.OrganisationView, "organisation.json")
    }
  end

  def render("organisation.json", %{organisation: organisation}) do
    %{
      id: organisation.id,
      name: organisation.name,
      subdomain: organisation.subdomain,
      description: organisation.description,
      logo: organisation.logo
    }
  end
end
