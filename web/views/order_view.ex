defmodule Flexphoenix.OrderView do
  use Flexphoenix.Web, :view
  import Flexphoenix.RequestView, only: [asset_name: 1, project_name: 1]
  import Flexphoenix.LayoutView, only: [display_name: 1]
end
