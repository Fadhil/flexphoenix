defmodule Flexcility.RegistrationView do
  use Flexcility.Web, :view

  import Flexcility.LayoutView, only: [image: 1, thumb: 1]

  def display_invited_role(role) do
    case role.name do
      "Helpdesk" ->
        "As a Helpdesk User"
      "Technician" ->
        "As a Technician"
      "Engineer" ->
        "As an Engineer"
      "Admin" ->
        "As an Admin"
    end
  end
end
