defmodule Flexcility.Plugs.AuthorizeForOrganisation do
  @moduledoc """
    Plug to verify that a user that logged in actually is a member of the
    organisation being logged into
  """
  import Plug.Conn

  alias Flexcility.Organisation
  alias Flexcility.User
  alias Passport.Session
  alias Flexcility.Repo

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    organisation = conn.assigns.current_organisation

    case organisation_member?(user, organisation) do
      {:ok, user}->
        conn
      {:error, _message} ->
        conn
        |> Session.logout()
        |> Phoenix.Controller.put_flash(:error, "You are not a valid member of that organisation")
        |> Phoenix.Controller.redirect(to: Flexcility.SubdomainRouter.Helpers.session_path(conn, :new))
        |> halt
    end
  end

  def organisation_member?(user, organisation) do
    organisation = organisation |> Repo.preload([{:memberships, [:user]}])
    case Enum.member?(Enum.map(organisation.memberships, fn(x)-> x.user end), user) do
      true ->
        {:ok, user}
      false ->
        {:error, :not_organisation_member}
    end
  end
end
