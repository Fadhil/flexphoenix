defmodule Flexcility.Api.OrganisationController do
  use Flexcility.Web, :controller
  alias Flexcility.Organisation
  alias Flexcility.Role
  alias Flexcility.Membership
  alias Flexcility.Facility

  def create(conn, %{"organisation" => organisation_params, "organisation_facilities" => facilities_ids}) do
    current_user = conn.assigns.current_user
    role = Repo.get_by(Role, name: "Admin")
    facilities = facilities_ids |> Enum.map(fn fid -> Repo.get(Facility, fid) end )
    # Add this user as an Admin for this Organisation
    membership_changeset = Membership.changeset(%Membership{}, %{})
                            |> Ecto.Changeset.put_assoc(:user, current_user)
                            |> Ecto.Changeset.put_assoc(:role, role)
    # Organisation Changeset with Membership and Facilities
    changeset = Organisation.create_changeset(%Organisation{}, organisation_params)
                |> Ecto.Changeset.put_assoc(:memberships, [membership_changeset])
                |> Ecto.Changeset.put_assoc(:facilities, facilities)

    case Repo.insert(changeset) do
      {:ok, organisation} ->
        # Save images AFTER creating, so we get the correct id
        Organisation.image_changeset(organisation, organisation_params)
        |> Repo.update

        conn
        |> render("show.json", %{organisation: organisation})
      {:error, changeset} ->
        conn
        |> render(Flexcility.ErrorView, "error.json", %{errors: changeset.errors})
    end
  end
end
