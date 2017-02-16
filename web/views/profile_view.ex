defmodule Flexcility.ProfileView do
  use Flexcility.Web, :view

  import Flexcility.LayoutView, only: [
    display_name: 1, image: 1, profile_image: 1, thumb: 1
  ]

  def display_nickname(user) do
    case user.profile do
      nil ->
        nil
      profile ->
        full_name = display_name(user)
        case profile.full_name do
          nil ->
            nil
          ^full_name ->
            nil
          nickname ->
            nickname
        end
    end
  end
end
