defmodule Flexcility.SystemChannel do
  use Flexcility.Web, :channel
  alias Flexcility.Invitation
  alias Flexcility.Role
  require Logger
  def join("system:main", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (system:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("send_invite", payload, socket) do
    Logger.info("creating invitation" <> inspect(payload))
    role = Repo.get_by(Role, name: payload["role"])
    invitation_changeset = %Invitation{}
                          |> Invitation.changeset(%{
                              role_id: role.id, organisation_subdomain: payload["organisation_subdomain"],
                              inviter_id: payload["inviter_id"], invitee_email: payload["email"]
                            })
    Logger.info("the invitation changeset: " <> inspect(invitation_changeset))
    case Repo.insert(invitation_changeset) do
      {:ok, invitation} ->
        registration_link = Flexcility.Router.Helpers.registration_url(Flexcility.Endpoint, :new, invitation: invitation.id)

        Flexcility.Email.team_member_invitation(payload["email"], registration_link) |> Flexcility.Mailer.deliver_later

        {:reply, {:ok, %{success: true, message: "Created Invitation"}}, socket}
        # {:noreply, socket}
      {:error, %{errors: [invitee_email: {"has already been taken"}]}} ->

        {:reply, {:error, %{message: "You've already sent that invite"}}, socket}
      _ ->
        {:reply, {:error, %{message: "Something went wrong"}}, socket}
    end

  end

  # def handle_in("invitation_sent", payload, socket) do
  #   Logger.info("sent notification")
  #   {:noreply, socket}
  # end

# This is invoked every time a notification is being broadcast
# to the client. The default implementation is just to push it
# downstream but one could filter or change the event.
def handle_out(event, payload, socket) do
   push socket, event, payload
    {:noreply, socket}
end
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
