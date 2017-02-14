defmodule Flexcility.OrganisationView do
  use Flexcility.Web, :view
  import Flexcility.LayoutView, only: [display_name: 1,
                                        display_created_at: 1,
                                        image: 1]
end
