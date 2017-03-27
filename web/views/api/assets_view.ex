defmodule Flexcility.Api.AssetsView do
  use Flexcility.Web, :view

  def render("index.json", %{assets: assets}) do
    %{data: render_many(assets, Flexcility.Api.AssetsView, "assets.json")}
  end

  def render("show.json", %{assets: assets}) do
    %{data: render_one(assets, Flexcility.Api.AssetsView, "assets.json")}
  end

  def render("assets.json", %{assets: assets}) do
    %{id: assets.id,
      name: assets.name,
      model_id: assets.model_id,
      manufacturer: assets.manufacturer,
      photo: assets.photo}
  end
end
