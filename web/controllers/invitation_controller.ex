defmodule Flexcility.InvitationController do
  use Flexcility.Web, :controller

  alias Flexcility.Invitation
  alias Flexcility.Membership

  def index(conn, _params) do
    user_email = conn.assigns.current_user.email
    invitations_query = from i in Invitation,
                        where: i.invitee_email == ^user_email and i.accepted == false
    invitations = Repo.all(invitations_query)
    render(conn, "index.html", invitations: invitations)
  end

  def new(conn, _params) do
    changeset = Invitation.changeset(%Invitation{})
    render(conn, "new.html", changeset: changeset)
  end

  def view_invite(conn, %{"invitation_id" => id}) do
    invitation = Repo.get(Invitation, id)
                 |> Repo.preload([:role, :organisation, :inviter])
    render(conn, "view_invite.html", invitation: invitation)
  end

  def accept_invite(conn, %{"invitation_id" => id}) do
    invitation = Repo.get(Invitation, id)
                 |> Repo.preload([:role, :organisation, :inviter])
    membership_changeset = Membership.changeset(%Membership{}, %{})
                           |> Ecto.Changeset.put_assoc(:user, conn.assigns.current_user)
                           |> Ecto.Changeset.put_assoc(:role, invitation.role)
                           |> Ecto.Changeset.put_assoc(:organisation, invitation.organisation)
    case Repo.insert(membership_changeset) do
      {:ok, _membership} ->
        invitation |> Invitation.changeset(%{accepted: true}) |> Repo.update
        conn
        |> put_flash(:info, "Successfully joined " <> invitation.organisation.name)
        |> redirect(to: organisation_path(conn, :index))
      {:error, errors} ->
        conn
        |> put_flash(:info, "Failed to Join that Organisation")
        |> redirect(to: invitation_path(conn, :index))
    end
    redirect(conn, to: organisation_path(conn, :index))
  end

  def create(conn, %{"invitation" => invitation_params}) do
    changeset = Invitation.changeset(%Invitation{}, invitation_params)

    case Repo.insert(changeset) do
      {:ok, _invitation} ->
        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: invitation_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invitation = Repo.get!(Invitation, id)
    render(conn, "show.html", invitation: invitation)
  end

  def edit(conn, %{"id" => id}) do
    invitation = Repo.get!(Invitation, id)
    changeset = Invitation.changeset(invitation)
    render(conn, "edit.html", invitation: invitation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    invitation = Repo.get!(Invitation, id)
    changeset = Invitation.changeset(invitation, invitation_params)

    case Repo.update(changeset) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation updated successfully.")
        |> redirect(to: invitation_path(conn, :show, invitation))
      {:error, changeset} ->
        render(conn, "edit.html", invitation: invitation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Repo.get!(Invitation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: invitation_path(conn, :index))
  end
end
