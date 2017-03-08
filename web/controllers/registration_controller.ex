defmodule Flexcility.RegistrationController do
  use Flexcility.Web, :controller
  alias Passport.Session
  alias Flexcility.User
  alias Flexcility.Invitation
  alias Flexcility.Membership
  def new(conn, params) do
    changeset = User.changeset(%User{}, %{profile: %{}})
    conn
    |> put_layout("none.html")
    |> render(:new, user: changeset, changeset: changeset)
  end

  def create(conn, %{"user" => registration_params} = params) do
    invitation_key = params["invitation"]["key"]

    invitation = if(invitation_key) do
      Repo.get_by(Invitation, key: invitation_key)
      |> Invitation.with_associations
    else
      nil
    end

    case insert_user(params, registration_params)  do
      {:ok, user} ->
        conn
        |> accept_invitation_and_redirect(user, invitation, registration_params)
      {:error, changeset} ->
        invitation = invitation |> Repo.preload([:organisation, :role, {:inviter, :profile}])
        conn
        |> assign(:invitation, invitation)
        |> check_for_invitation_and_redirect(changeset, invitation)
    end
  end

  defp get_full_name(%{"full_name" => full_name} = registration_params) do
    full_name
  end

  defp accept_invitation_and_redirect(
    conn, user, invitation, %{"email" => email, "password" => pass}
  ) do
    case invitation do
      nil ->
        case Session.login(conn, email, pass) do
          {:ok, conn} ->
            conn
            |> put_flash(:info, "Account created!")
            |> redirect(to: page_path(conn, :index))
          {:error, _reason, conn} ->
            conn
            |> put_flash(:error, "Invalid username/password combination")
            |> put_layout("none.html")
            |> render(:new)
        end

      _ ->
        conn
        |> accept_invitation(invitation)
        |> join_organisation(user, invitation)
        |> put_flash(:info, "Welcome to #{invitation.organisation.name}. Login to begin.")
        |> redirect(to: Flexcility.SubdomainRouter.Helpers.session_path(conn, :new))
        # case Session.login(conn, email, pass) do
        #   {:ok, conn} ->
        #     conn
        #     |> accept_invitation(invitation)
        #     |> join_organisation(user, invitation)
        #     |> put_flash(:info, "Welcome to #{invitation.organisation.name}. Login to begin.")
        #     |> redirect(to: Flexcility.SubdomainRouter.Helpers.session_path(conn, :new))
        #   {:error, _reason, conn} ->
        #     conn
        #     |> put_flash(:error, "Invalid username/password combination")
        #     |> redirect(to: Flexcility.SubdomainRouter.Helpers.dashboard_path(conn, :index))
        # end

    end
  end

  defp accept_invitation(conn, invitation) do
    case Invitation.accept(invitation) do
      {:ok, invitation} ->
        conn
      {:error, changeset} ->
        conn
        |> put_layout("none.html")
        |> render(Flexcility.ErrorView, "error.html", error_message: "Unable to accept the Invitation. Contact the Admins for help")
        |> halt
    end
  end

  defp join_organisation(conn, user, invitation) do
    invitation = Invitation.with_associations(invitation)
    # Add this user as the specified role in the invitation for this Organisation
    membership_changeset = Membership.invitation_changeset(%Membership{}, user, invitation)
    case Repo.insert(membership_changeset) do
      {:ok, organisation} ->
        conn
      {:error, changeset} ->
        conn
        |> render(Flexcility.ErrorView, "error.json", %{errors: changeset.errors})
        |> halt
    end
  end

  defp check_for_invitation_and_redirect(conn, changeset, invitation) do
    case invitation do
      nil ->
        conn
        |> put_layout("none.html")
        |> render(:new, user: changeset, changeset: changeset)
      _ ->
        conn
        |> put_layout("none.html")
        |> render(Flexcility.RegistrationView, "invitation.html", changeset: changeset, invitation: invitation)
    end
  end

  defp insert_user(params, registration_params) do
    changeset = get_user_changeset_with_profile(registration_params)
    Repo.insert(changeset)
  end

  def get_user_changeset_with_profile(params) do
    profile_params = %{"full_name" => get_full_name(params)}
    params_with_profile = params |> Map.put("profile", profile_params)
    changeset = User.registration_changeset(%User{}, params_with_profile)
  end
end
