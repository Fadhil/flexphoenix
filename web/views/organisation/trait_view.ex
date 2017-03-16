defmodule Flexcility.Organisation.TraitView do
  use Flexcility.Web, :view

  def display_organisation_trait_check(organisation, trait) do
    case Enum.member?(organisation.traits, trait) do
      true ->
        "checked"
      _ ->
        ""
    end
  end
end
