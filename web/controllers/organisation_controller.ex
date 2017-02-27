defmodule Flexcility.OrganisationController do
  use Flexcility.Web, :controller
  alias Flexcility.Organisation
  alias Flexcility.Role
  alias Flexcility.Membership
  alias Flexcility.Facility

  def index(conn, _params) do
    user = conn.assigns.current_user
    pending_invitation = get_session(conn, :invitation_key)
    case pending_invitation do
      nil ->
        user = user |> Repo.preload(:organisations)
        organisations = user.organisations
        case organisations do
          [] ->
            facilities = Repo.all(Facility)
            changeset = Organisation.changeset(%Organisation{})
            conn
            |> assign(:page_title, "Define Your Organisation")
            |> render("index_empty.html", organisation: %Organisation{}, changeset: changeset, action: organisation_path(conn, :create), facilities: facilities)
          _ ->
            conn
            |> assign(:page_title, "Organisations")
            |> render("index.html", organisations: organisations)
        end
      "" ->
        user = user |> Repo.preload(:organisations)
        organisations = user.organisations
        case organisations do
          [] ->
            render(conn, "index_empty.html", organisations: organisations)
          _ ->
            render(conn, "index.html", organisations: organisations)
        end

      invitation_id ->
        conn
        |> redirect(to: invitation_view_path(conn, :view_invite, invitation_id))
    end
  end

  def new(conn, _params) do
    changeset = Organisation.changeset(%Organisation{})
    conn = conn |> assign(:page_title, "New Organisation")
    render(conn, "new.html", changeset: changeset, action_name: action_name(conn))
  end

  def create(conn, %{"organisation" => organisation_params}) do
    current_user = conn.assigns.current_user
    role = Repo.get_by(Role, name: "Admin")
    membership_changeset = Membership.changeset(%Membership{}, %{})
                            |> Ecto.Changeset.put_assoc(:user, current_user)
                            |> Ecto.Changeset.put_assoc(:role, role)
    changeset = Organisation.create_changeset(%Organisation{}, organisation_params)
                |> Ecto.Changeset.put_assoc(:memberships, [membership_changeset])

    case Repo.insert(changeset) do
      {:ok, organisation} ->
        # Save images AFTER creating, so we get the correct id
        Organisation.image_changeset(organisation, organisation_params)
        |> Repo.update

        conn
        |> put_flash(:info, "Organisation created successfully.")
        |> redirect(to: organisation_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", changeset: changeset,action_name: action_name(conn))
    end
  end

  def show(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id)
                   |> Repo.preload([{:memberships, [{:user, :profile}, :role]}])
    facilities = []
    members = Organisation.get_members(organisation)
    render(conn, "show.html", organisation: organisation, facilities: facilities, members: members)
  end

  def edit(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id)
    changeset = Organisation.changeset(organisation)
    conn = conn |> assign(:page_title, organisation.name)
    render(conn, "edit.html", organisation: organisation, changeset: changeset, action_name: action_name(conn))
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
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("edit.html", organisation: organisation, changeset: changeset)
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

  def send_an_email(conn, _params) do
    Flexcility.Email.welcome_text_email("fadhil.luqman@gmail.com") |> Flexcility.Mailer.deliver_later
    conn
    |> put_flash(:info, "Sent an email to you!")
    |> redirect(to: "/")
  end

  def manage(conn, %{"organisation_id" => id}) do
    conn
    |> assign(:page_title, "Manage Organisation")
    |> render("manage.html")
  end

  def subdomain_unique(conn, %{"organisation" => %{"subdomain" => subdomain}}) do
    subdomain_unique = case Repo.get_by(Organisation, subdomain: subdomain) do
      nil ->
        "true"
      _ ->
        "That subdomain has already been taken"
    end
    render conn, "subdomain_unique.json", subdomain_unique: subdomain_unique
  end
end
