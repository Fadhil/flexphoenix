defmodule Flexcility.Subdomain.InvitationController do
  use Flexcility.Web, :controller
  alias Flexcility.Invitation
  alias Flexcility.User
  alias Flexcility.Membership

  def accept(conn, %{"invitation_key" => invitation_key}) do
    invitation = Repo.get_by(Invitation, key: invitation_key, accepted: false)
                 |> Invitation.with_associations
    membership_changeset = Membership.changeset(%Membership{}, %{})
                           |> Ecto.Changeset.put_assoc(:user, conn.assigns.current_user)
                           |> Ecto.Changeset.put_assoc(:role, invitation.role)
                           |> Ecto.Changeset.put_assoc(:organisation, invitation.organisation)
    case Repo.insert(membership_changeset) do
      {:ok, _membership} ->
        invitation |> Invitation.changeset(%{accepted: true}) |> Repo.update
        conn
        |> put_flash(:info, "Successfully joined " <> invitation.organisation.name <> ". Login to start helping out")
        |> render(Flexcility.Subdomain.SessionView, :new)
        # |> redirect(to: Flexcility.SubdomainRouter.Helpers.session_path(conn, :new))
      {:error, errors} ->
        conn
        |> render(Flexcility.ErrorView, "error.html", error_message: "Could not join that organisation")
    end
  end

  def reject(conn, params) do
    text conn, "Rejected"
  end

  def show(conn, %{"invitation_key" => invitation_key}) when is_bitstring(invitation_key) do
    case Repo.get_by(Invitation, key: invitation_key, accepted: false) do
      nil ->
        conn
        |> put_layout("none.html")
        |> render(Flexcility.ErrorView, "error.html", error_message: "That invitation key is invalid")
      invitation ->
        check_invitation_email(conn, invitation)
    end
  end

  defp check_invitation_email(conn, invitation) do
    case email_matches_existing_user(conn, invitation) do
      {:ok, user} ->
        invitation = invitation |> Invitation.with_associations
        case email_matches_current_user(conn, invitation) do
          {:ok, user} ->
            conn
            |> put_layout("none.html")
            |> render("show.html", invitation: invitation)
          {:error, :not_logged_in} ->
            conn
            |> put_layout("none.html")
            |> render("show.html", invitation: invitation)
          {:error, :wrong_invitee_email} ->
            conn
            |> put_layout("none.html")
            |> render(Flexcility.ErrorView, "error.html", error_message: "This invitation was meant for someone else")
        end
      {:error, error} ->
        changeset = User.changeset(%User{}, %{profile: %{}})
        invitation = invitation |> Repo.preload([:organisation, :role, {:inviter, :profile}])
        conn
        |> put_layout("none.html")
        |> assign(:invitation, invitation)
        |> render(Flexcility.RegistrationView, "invitation.html", changeset: changeset, invitation: invitation)
    end
  end

  defp email_matches_current_user(conn, invitation) do
    user = conn.assigns.current_user
    if(user) do
      if(user.email == invitation.invitee_email) do
        {:ok, user}
      else
        {:error, :wrong_invitee_email}
      end
    else
      {:error, :not_logged_in}
    end
  end

  defp email_matches_existing_user(conn, invitation) do
    invitee_email = invitation.invitee_email
    case Repo.get_by(User, email: invitee_email) do
      nil ->
        {:error, :user_not_found}
      user ->
        {:ok, user}
    end
  end
end
