defmodule Flexcility.Subdomain.SessionController do
  use Flexcility.Web, :controller
  alias Flexcility.Invitation

  # import Flexcility.SubdomainRouter.Helpers
  alias Passport.Session


  def new(conn, _) do
    conn
    |> put_layout("none.html")
    |> render(:new)
  end

  def invitation(conn, %{"invitation_key" => invitation_key} =params) do
    case Repo.get_by(Invitation, key: invitation_key, accepted: false) do
      nil ->
        conn
        |> put_layout("none.html")
        |> render(Flexcility.ErrorView, "error.html", error_message: "That invitation key is invalid")
      invitation ->
        invitation = invitation |> Invitation.with_associations
        conn
        |> put_layout("none.html")
        |> assign(:invitation, invitation)
        |> render(:invitation)
    end
  end
  
  def create(conn, %{"session" => %{"email" => "", "password" => ""}}) do
    conn
    |> put_flash(:error, "You must enter an email and a password")
    |> put_layout("none.html")
    |> render(:new)
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}} = params) do
    redirect_path = Flexcility.SubdomainRouter.Helpers.dashboard_path(conn, :index)
    case Session.login(conn, email, pass) do
    {:ok, conn} ->
      organisation = conn.assigns.current_organisation
      user = conn.assigns.current_user

      case Flexcility.Plugs.AuthorizeForOrganisation.organisation_member?(user, organisation) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Welcome back!")
          |> redirect(to: redirect_path)
        {:error, :not_organisation_member} ->
          conn
          |> put_flash(:error, "You're not a valid member of this organisation")
          |> put_layout("none.html")
          |> render(:new)
      end

    {:error, _reason, conn} ->
      conn
      |> put_flash(:error, "Invalid username/password combination")
      |> put_layout("none.html")
      |> render(:new)
    end
  end

  def delete(conn, _) do
    conn
    |> Session.logout()
    |> put_flash(:info, "You have been logged out")
    |> redirect(to: Flexcility.SubdomainRouter.Helpers.session_path(conn, :new))
  end
end
