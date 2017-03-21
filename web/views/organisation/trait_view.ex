defmodule Flexcility.Organisation.TraitView do
  use Flexcility.Web, :view

  def display_organisation_trait_check(organisation, trait) do
    Enum.member?(organisation.traits, trait)
  end

  def display_organisation_facility_check(organisation, facility) do
    Enum.member?(organisation.facilities, facility)
  end
end
