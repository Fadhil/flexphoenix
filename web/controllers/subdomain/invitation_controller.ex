defmodule Flexcility.Subdomain.InvitationController do
  use Flexcility.Web, :controller
  alias Flexcility.Invitation
  alias Flexcility.User

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
        conn
        |> put_layout("none.html")
        |> render("show.html")
      {:error, error} ->
        changeset = User.changeset(%User{}, %{profile: %{}})
        invitation = invitation |> Repo.preload([:organisation, :role, {:inviter, :profile}])
        conn
        |> put_layout("none.html")
        |> assign(:invitation_key, invitation.key)
        |> render(Flexcility.RegistrationView, "invitation.html", changeset: changeset, invitation: invitation)
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
