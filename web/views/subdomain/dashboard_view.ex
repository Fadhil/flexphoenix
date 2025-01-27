defmodule Flexcility.Subdomain.DashboardView do
  use Flexcility.Web, :view
  alias Flexcility.Organisation
  import Flexcility.LayoutView, only: [display_name: 1,
                                        display_created_at: 1,
                                        image: 1, thumb: 1]

  def get_members(organisation) do
    Organisation.get_members(organisation)
  end
end
