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

    invitation_key = params["invitation"]["key"]
    redirect_path = case invitation_key do
      nil ->
        Flexcility.SubdomainRouter.Helpers.dashboard_path(conn, :index)
      invitation_key ->
        Flexcility.SubdomainRouter.Helpers.dashboard_path(conn, :index)
    end
    case Session.login(conn, email, pass) do
    {:ok, conn} ->
      conn
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: redirect_path)
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
