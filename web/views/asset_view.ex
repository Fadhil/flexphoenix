defmodule Flexcility.AssetView do
  use Flexcility.Web, :view
  import Flexcility.LayoutView, only: [image: 1]

	def render("index.json", struct) do
    %{assets: assets} = struct
    assets = assets
      |> Enum.map(
          fn x ->
            Map.drop(x, [
              :__meta__, :__struct__, :site, :requests
            ])
          end
        )
    assets
  end
end
