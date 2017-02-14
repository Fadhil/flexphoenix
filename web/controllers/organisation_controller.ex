defmodule Flexcility.OrganisationController do
  use Flexcility.Web, :controller
  alias Flexcility.Organisation
  alias Flexcility.Role
  alias Flexcility.Membership

  def index(conn, _params) do
    user = conn.assigns.current_user
    user = user |> Repo.preload(:organisations)
    organisations = user.organisations
    case organisations do
      [] ->
        render(conn, "index_empty.html", organisations: organisations)
      _ ->
        render(conn, "index.html", organisations: organisations)
    end
  end

  def new(conn, _params) do
    changeset = Organisation.changeset(%Organisation{})
    render(conn, "new.html", changeset: changeset, page_title: "New Organisation")
  end

  def create(conn, %{"organisation" => organisation_params}) do
    current_user = conn.assigns.current_user
    role = Repo.get_by(Role, name: "Admin")
    membership_changeset = Membership.changeset(%Membership{}, %{})
                            |> Ecto.Changeset.put_assoc(:user, current_user)
                            |> Ecto.Changeset.put_assoc(:role, role)
    changeset = Organisation.changeset(%Organisation{}, organisation_params)
                |> Ecto.Changeset.put_assoc(:memberships, [membership_changeset])

    case Repo.insert(changeset) do
      {:ok, _organisation} ->
        conn
        |> put_flash(:info, "Organisation created successfully.")
        |> redirect(to: organisation_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id)
    render(conn, "show.html", organisation: organisation)
  end

  def edit(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id)
    changeset = Organisation.changeset(organisation)
    render(conn, "edit.html", organisation: organisation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organisation" => organisation_params}) do
    organisation = Repo.get!(Organisation, id)
    changeset = Organisation.changeset(organisation, organisation_params)

    case Repo.update(changeset) do
      {:ok, organisation} ->
        conn
        |> put_flash(:info, "Organisation updated successfully.")
        |> redirect(to: organisation_path(conn, :show, organisation))
      {:error, changeset} ->
        render(conn, "edit.html", organisation: organisation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(organisation)

    conn
    |> put_flash(:info, "Organisation deleted successfully.")
    |> redirect(to: organisation_path(conn, :index))
  end
end
