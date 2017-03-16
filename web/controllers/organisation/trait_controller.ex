defmodule Flexcility.Organisation.TraitController do
  use Flexcility.Web, :controller

  alias Flexcility.Trait
  alias Flexcility.Organisation
  import Ecto.Query, only: [from: 2]
  require IEx

  plug :assign_organisation

  def index(conn, %{"organisation_id" => organisation_id}) do
    organisation = Repo.get(Organisation, organisation_id)
      |> Repo.preload([:traits])
    traits = Repo.all(Trait)
    changeset = Organisation.changeset(organisation, %{})
    render(conn, "index.html", traits: traits, organisation: organisation,
     page_title: "#{organisation.name} Assigned Traits", changeset: changeset,
     action: organisation_trait_path(conn, :update, organisation)
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
    "organisation_id" => id, "organisation_traits" => added_trait_ids_param,
    "organisation_unchecked_traits" => removed_trait_ids_param
  } = params) do
    added_trait_ids = trait_ids_from_param(added_trait_ids_param)
    removed_trait_ids = trait_ids_from_param(removed_trait_ids_param)
    remove_message = remove_traits(id, removed_trait_ids)
      |> removed_traits_flash_messages()

    add_message = add_traits(id, added_trait_ids)
      |> added_traits_flash_messages()

    full_messages = case [remove_message, add_message] do
      [{key, message1}, {key, message2}] ->
        [{key, message1 <> message2}]
      [{key1, message1}, {key2, message2}] ->
        [{key1, message1}, {key2, message2}]
    end

    IEx.pry
    conn
    |> put_full_messages(full_messages)
    |> redirect(to: organisation_trait_path(conn, :index, id))

  end

  def update(conn, %{
    "organisation_id" => id, "organisation_traits" => added_trait_ids
  }) do
    trait_ids = trait_ids_from_param(added_trait_ids)
    {key, message} = add_traits(id, trait_ids)
      |> added_traits_flash_messages()

    conn
    |> put_flash(key, message)
    |> redirect(to: organisation_trait_path(conn, :index, id))
  end

  def update(conn, %{
    "organisation_id" => id,
    "organisation_unchecked_traits" => removed_trait_ids_param
  }) do
    removed_trait_ids = removed_trait_ids_param |> trait_ids_from_param
    {key, message} = remove_traits(id, removed_trait_ids)
      |> removed_traits_flash_messages
    conn
    |> put_flash(key, message)
    |> redirect(to: organisation_trait_path(conn, :index, id))
  end

  def update(conn, %{
    "organisation_id" => id
  }) do
    conn
    |> put_flash(:info, "No changes made")
    |> redirect(to: organisation_trait_path(conn, :index, id ))
  end

  defp put_full_messages(conn, full_messages) do
    Enum.each(full_messages, fn({k,m})->
      conn = conn |> put_flash(k,m)
    end)
    conn
  end

  defp removed_traits_flash_messages(result) do
    case result do
      {:ok, 1} ->
        {:success, "Removed 1 trait"}
      {:ok, number} ->
        {:success, "Removed #{number} traits"}
      {:error, :no_traits_removed} ->
        {:error, "Unable to remove traits"}
    end
  end

  defp added_traits_flash_messages(result) do
    case result do
      {:ok, 0} ->
        {:info, "No Traits were added"}
      {:ok, 1} ->
        {:success, "Added 1 trait"}
      {:ok, number} ->
        {:success, "Added #{number} traits"}
      {:error, :no_traits_added} ->
        {:error, "Unable to add traits"}
    end
  end

  def trait_ids_from_param(trait_ids_param) do
    trait_ids_param |> Enum.map(fn(x) ->
      case Integer.parse(x) do
        :error -> nil
        {integer, _} -> integer
      end
    end) |> Enum.filter(fn(z) -> z != nil end )
  end

  defp add_traits(organisation_id, trait_ids) do
    organisation = Repo.get!(Organisation, organisation_id)
      |> Repo.preload([:traits])
    traits_query = from t in Trait, where: t.id in ^trait_ids
    traits = traits_query |> Repo.all
    added_traits = traits
      |> Enum.filter(fn(t) -> !Enum.member?(organisation.traits, t) end)
    case added_traits do
      [] ->
        {:ok, 0}
      _ ->
      changeset = Organisation.changeset(organisation)
        |> Ecto.Changeset.put_assoc(:traits, traits)

      case Repo.update(changeset) do
        {:ok, changeset} ->
          number_of_traits = Enum.count(added_traits)
          {:ok, number_of_traits}
        {:error, changeset} ->
          {:error, :no_traits_added}
      end
    end
  end

  defp remove_traits(organisation_id, trait_ids) do
    {organisation_id, _} = Integer.parse(organisation_id)
    remove_query =
      from o in "organisations_traits",
      where: o.organisation_id == ^organisation_id and o.trait_id in ^trait_ids
    case Repo.delete_all(remove_query) do
      {0, _} ->
        {:error, :no_traits_removed}
      {number, _} ->
        {:ok, number}
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
