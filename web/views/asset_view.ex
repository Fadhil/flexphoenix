defmodule Flexphoenix.AssetView do
  use Flexphoenix.Web, :view
  import Flexphoenix.LayoutView, only: [image: 1]

	def render("index.json", struct) do
    %{assets: assets} = struct
    assets = assets
      |> Enum.map(
          fn x ->
            Map.drop(x, [
              :__meta__, :__struct__, :project, :requests
            ])
          end
        )
    assets
  end
end
