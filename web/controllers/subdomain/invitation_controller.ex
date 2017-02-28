defmodule Flexcility.Subdomain.InvitationController do
  use Flexcility.Web, :controller
  alias Flexcility.Invitation

  def show(conn, %{"invitation_key" => invitation_key}) when is_bitstring(invitation_key) do
    case Repo.get_by(Invitation, key: invitation_key) do
      nil ->
        conn
        |> put_layout("none.html")
        |> render(Flexcility.ErrorView, "error.html", error_message: "You need a valid invitation key")
      %Invitation{} ->
        conn
        |> render("show.html")
    end
  end
end
