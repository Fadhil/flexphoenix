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
    role = Repo.get_by(Role, name: "Helpdesk")
    invitation_changeset = %Invitation{}
                          |> Invitation.changeset(%{ role_id: role.id, organisation_id: payload["organisation_id"], inviter_id: payload["inviter_id"]})
    Repo.insert(invitation_changeset)
    broadcast socket, "invitation_sent", payload
    {:noreply, socket}
  end

  def handle_in("invitation_sent", payload, socket) do
    Logger.info("sent notification")
    {:noreply, socket}
  end

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
