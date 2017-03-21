defmodule Flexcility.Organisation.SiteController do
  use Flexcility.Web, :controller

  alias Flexcility.Site
  alias Flexcility.UsersRole
  alias Flexcility.Role
  alias Flexcility.User
  plug Flexcility.Plugs.AssignOrganisation
  import Ecto.Query, only: [from: 2]

  plug :scrub_params, "site" when action in [:create, :update]

  def index(
    %{assigns: %{current_user: current_user}}=conn, _params
  ) do
    user = current_user |> Repo.preload([:sites])
    sites = user.sites
    render(conn, "index.html", sites: sites)
  end

  def invite_user(conn, %{
    "invite_user" => %{
      "user_email" => email,
      "user_role" => role_id
    },
    "site_id" => site_id
  }) do

    user = User |> Repo.get_by(email: email)
    site = Site |> Repo.get(site_id)
    role = Role |> Repo.get(role_id)
    user_id = case user do
      nil -> nil
      user -> user.id
    end
    users_role_changes= %{
      role_id: role.id, user_id: user_id, site_id: site.id
    }

    case user_id do
      nil ->
        conn
        |> put_flash(:error, "That user cannot be added to this site")
        |> redirect(to: organisation_site_path(conn, :show, conn.assigns.organisation.id, site))
      _ ->
        changeset = UsersRole.create_changeset(
          UsersRole,Repo, users_role_changes
        )

        case Repo.insert_or_update(changeset) do
          {:ok, _users_role} ->
            conn
            |> put_flash(:success, "Successfully invited #{email} as #{role.name}")
            |> redirect(to: organisation_site_path(conn, :show, site, conn.assigns.organisation.id))
          {:error, _changeset} ->
            conn
            |> put_flash(:error, "That user cannot be added to this site")
            |> redirect(to: organisation_site_path(conn, :show, site, conn.assigns.organisation.id))
        end
    end
  end

  def new(conn, _params) do
    changeset = Site.changeset(%Site{})
    render(conn, "new.html", changeset: changeset, conn: conn)
  end

  def create(conn, %{"site" => site_params}) do
    current_user = conn.assigns.current_user
    changeset = Site.create_changeset(%Site{},current_user.id, site_params)

    case Repo.insert(changeset) do
      {:ok, site} ->
        conn
        |> put_flash(:success, "Site created successfully.")
        |> redirect(to: organisation_site_path(conn, :show, conn.assigns.organisation.id, site))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    roles = Role |> Repo.all
    roles_select_list = roles |> Enum.map(fn x -> {"#{x.name}", x.id} end)
    site = Site |> Site.with_owner |> Repo.get!(id)
    query = from ur in UsersRole,
            where: ur.site_id == ^site.id
    users_roles = Repo.all(query)
                  |> Repo.preload([:user, :site, :role])
    conn = conn |> assign(:page_title, site.name)
    render(conn, "show.html", site: site, roles_select_list: roles_select_list, site_members: users_roles)
  end

  def edit(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)
    changeset = Site.changeset(site)
    render(conn, "edit.html", site: site, changeset: changeset)
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    site = Repo.get!(Site, id)
    changeset = Site.changeset(site, site_params)

    case Repo.update(changeset) do
      {:ok, site} ->
        conn
        |> put_flash(:success, "Site updated successfully.")
        |> redirect(to: organisation_site_path(conn, :show, site, conn.assigns.organisation.id))
      {:error, changeset} ->
        render(conn, "edit.html", site: site, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(site)

    conn
    |> put_flash(:success, "Site deleted successfully.")
    |> redirect(to: organisation_site_path(conn, :index, conn.assigns.organisation.id))
  end
end
