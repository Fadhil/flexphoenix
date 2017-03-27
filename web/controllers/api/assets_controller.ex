defmodule Flexcility.Api.AssetsController do
  use Flexcility.Web, :controller

  alias Flexcility.Asset

  def index(conn, _params) do
    assets = Repo.all(Asset)
    render(conn, "index.json", assets: assets)
  end

  def create(conn, %{"assets" => assets_params}) do
    changeset = Asset.changeset(%Asset{}, assets_params)

    case Repo.insert(changeset) do
      {:ok, assets} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_site_assets_path(conn, :show, assets))
        |> render("show.json", assets: assets)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Flexcility.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    assets = Repo.get!(Asset, id)
    render(conn, "show.json", assets: assets)
  end

  def update(conn, %{"id" => id, "assets" => assets_params}) do
    assets = Repo.get!(Asset, id)
    changeset = Asset.changeset(assets, assets_params)

    case Repo.update(changeset) do
      {:ok, assets} ->
        render(conn, "show.json", assets: assets)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Flexcility.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    assets = Repo.get!(Asset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(assets)

    send_resp(conn, :no_content, "")
  end
end
