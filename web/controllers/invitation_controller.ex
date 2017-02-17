defmodule Flexcility.InvitationController do
  use Flexcility.Web, :controller

  alias Flexcility.Invitation

  def index(conn, _params) do
    invitations = Repo.all(Invitation)
    render(conn, "index.html", invitations: invitations)
  end

  def new(conn, _params) do
    changeset = Invitation.changeset(%Invitation{})
    render(conn, "new.html", changeset: changeset)
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
