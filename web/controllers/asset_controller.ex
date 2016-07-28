defmodule Flexphoenix.AssetController do
  use Flexphoenix.Web, :controller
  alias Flexphoenix.Asset

  plug :scrub_params, "asset" when action in [:create, :update]
  plug :assign_project

  def index(conn, _params) do
    assets = Repo.all(Asset)
    render(conn, "index.html", assets: assets)
  end

  def new(conn, _params) do
    changeset = Asset.changeset(%Asset{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"asset" => asset_params}) do
    changeset = Asset.changeset(%Asset{}, asset_params)

    case Repo.insert(changeset) do
      {:ok, asset} ->
        conn
        |> put_flash(:info, "Asset created successfully.")
        |> redirect(to: project_asset_path(conn, :index, conn.assigns.project.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset,project_id: 7)
    end
  end

  def show(conn, %{"id" => id}) do
    asset = Repo.get!(Asset, id)
    render(conn, "show.html", asset: asset)
  end

  def edit(conn, %{"id" => id}) do
    asset = Repo.get!(Asset, id)
    changeset = Asset.changeset(asset)
    render(conn, "edit.html", asset: asset, changeset: changeset)
  end

  def update(conn, %{"id" => id, "asset" => asset_params}) do
    asset = Repo.get!(Asset, id)
    changeset = Asset.changeset(asset, asset_params)

    case Repo.update(changeset) do
      {:ok, asset} ->
        conn
        |> put_flash(:info, "Asset updated successfully.")
        |> redirect(to: project_asset_path(conn, :show, conn.assigns.project.id, asset))
      {:error, changeset} ->
        render(conn, "edit.html", asset: asset, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    asset = Repo.get!(Asset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(asset)

    conn
    |> put_flash(:info, "Asset deleted successfully.")
    |> redirect(to: project_asset_path(conn, :index, conn.assigns.project.id))
  end

  def assign_project(conn, opts) do
    %{params: %{"project_id" => project_id}} = conn
    project = Repo.get(Flexphoenix.Project, project_id)
    assign(conn, :project, project)
  end
end
