defmodule Flexcility.Subdomain.ProfileView do
  use Flexcility.Web, :view

  import Flexcility.LayoutView, only: [
    display_name: 1, image: 1, profile_image: 1, thumb: 1
  ]
end
