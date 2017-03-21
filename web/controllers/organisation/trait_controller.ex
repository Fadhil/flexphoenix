defmodule Flexcility.Organisation.TraitController do
  use Flexcility.Web, :controller

  alias Flexcility.Trait
  alias Flexcility.Facility
  alias Flexcility.Organisation
  alias Flexcility.Utils.Form
  plug :assign_organisation

  def index(conn, %{"organisation_id" => organisation_id}) do
    organisation = Repo.get(Organisation, organisation_id)
      |> Repo.preload([:traits, :facilities])
    traits = Repo.all(Trait)
    facilities = Repo.all(Facility)
    changeset = Organisation.changeset(organisation, %{})
    render(conn, "index.html", traits: traits, organisation: organisation,
     page_title: "#{organisation.name} Assigned Traits", changeset: changeset,
     action: organisation_trait_path(conn, :update, organisation),
     facilities: facilities
    )
  end

  def new(conn, _params) do
    changeset = Trait.changeset(%Trait{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"trait" => trait_params}=params) do

    changeset = Trait.changeset(%Trait{}, trait_params)

    case Repo.insert(changeset) do
      {:ok, _trait} ->
        conn
        |> put_flash(:info, "Trait created successfully.")
        |> redirect(to: organisation_trait_path(conn, :index, params[:organisation_id]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    trait = Repo.get!(Trait, id)
    render(conn, "show.html", trait: trait)
  end

  def edit(conn, %{"id" => id}) do
    trait = Repo.get!(Trait, id)
    changeset = Trait.changeset(trait)
    render(conn, "edit.html", trait: trait, changeset: changeset)
  end

  def update(conn, %{
    "organisation_id" => id, "organisation_traits" => trait_ids_params,
    "organisation_facilities" => facilities_ids_params
  } = params) do

    organisation = Repo.get(Organisation, id)
      |> Repo.preload([:facilities, :traits])

    added_traits = trait_ids_params
      |> Form.filter_checkbox_params(true)
      |> Form.ids_from_strings
      |> Trait.all

    removed_traits = trait_ids_params
      |> Form.filter_checkbox_params(false)
      |> Form.ids_from_strings
      |> Trait.all

    added_facilities = facilities_ids_params
      |> Form.filter_checkbox_params(true)
      |> Form.ids_from_strings
      |> Facility.all

    removed_facilities = facilities_ids_params
      |> Form.filter_checkbox_params(false)
      |> Form.ids_from_strings
      |> Facility.all

    organisation_changeset = organisation
      |> Organisation.changeset
      |> remove_traits(removed_traits)
      |> add_traits(added_traits)
      |> remove_facilities(removed_facilities)
      |> add_facilities(added_facilities)

    case Repo.update(organisation_changeset) do
      {:ok, changeset} ->
        conn
        |> put_flash(:success, "Successfully updated traits and facilities")
        |> redirect(to: organisation_trait_path(conn, :index, id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update traits and facilities")
        |> redirect(to: organisation_trait_path(conn, :index, id))
    end

  end

  defp update_facilities(organisation_id, facilities_ids_params) do
    organisation = Repo.get(Organisation, organisation_id)
      |> Repo.preload([:facilities])
  end

  defp add_facilities(changeset, facilities) do
    added_facilities = facilities
      |> Enum.filter(fn(t) -> !Enum.member?(changeset.data.facilities, t) end)
    case added_facilities do
      [] ->
        changeset
      _ ->
        changeset
        |> Ecto.Changeset.put_assoc(:facilities, facilities)

    end
  end

  def remove_facilities(changeset, facilities) do
    member_facility_ids_to_remove = facilities
      |> Enum.filter(fn(facility) -> Enum.member?(changeset.data.facilities, facility) end)
      |> Enum.map(fn(facility) -> facility.id end)
    remove_query = from t in "facilities_organisations",
      where: t.organisation_id == ^changeset.data.id and t.facility_id in ^member_facility_ids_to_remove

    case Repo.delete_all(remove_query) do
      {0, _} ->
        changeset
      {number, _} ->
        changeset = Repo.get(Organisation, changeset.data.id)
          |> Repo.preload([:facilities, :traits])
          |> Organisation.changeset
    end
  end

  defp add_traits(changeset, traits) do
    added_traits = traits
      |> Enum.filter(fn(t) -> !Enum.member?(changeset.data.traits, t) end)
    case added_traits do
      [] ->
        changeset
      _ ->
        changeset
        |> Ecto.Changeset.put_assoc(:traits, traits)

    end
  end

  def remove_traits(changeset, traits) do
    member_trait_ids_to_remove = traits
      |> Enum.filter(fn(trait) -> Enum.member?(changeset.data.traits, trait) end)
      |> Enum.map(fn(trait) -> trait.id end)
    remove_query = from t in "organisations_traits",
      where: t.organisation_id == ^changeset.data.id and t.trait_id in ^member_trait_ids_to_remove

    case Repo.delete_all(remove_query) do
      {0, _} ->
        changeset
      {number, _} ->
        organisation = Repo.get(Organisation, changeset.data.id)
          |> Repo.preload([:facilities, :traits])
        changeset = organisation
          |> Organisation.changeset
    end
  end

  def delete(conn, %{"id" => id}=params) do
    trait = Repo.get!(Trait, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(trait)

    conn
    |> put_flash(:info, "Trait deleted successfully.")
    |> redirect(to: organisation_trait_path(conn, :index, params[:organisation_id]))
  end

  def assign_organisation(%{
      params: %{"organisation_id" => organisation_id}
    } = conn,
    _params) do
    conn
    |> assign(:organisation, Repo.get(Organisation, organisation_id ))
  end
end
