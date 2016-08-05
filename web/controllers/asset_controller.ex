defmodule Flexphoenix.AssetController do
  use Flexphoenix.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Flexphoenix.Asset

  plug :scrub_params, "asset" when action in [:create, :update]
  plug :assign_project

  def index(conn, _params) do
    %{"project_id" => project_id} = conn.params
    project_id = String.to_integer(project_id)
    query = from a in Asset,
            join: p in assoc(a, :project),
            where: p.id == ^project_id,
            preload: [project: p]
    assets = Repo.all(query)

    render(conn, assets: assets)
  end

  def new(conn, _params) do
    changeset = Asset.changeset(%Asset{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"asset" => asset_params}) do
    changeset = Asset.create_changeset(%Asset{}, conn.assigns.project.id, asset_params)

    case Repo.insert(changeset) do
      {:ok, _asset} ->
        conn
        |> put_flash(:info, "Asset created successfully.")
        |> redirect(to: project_asset_path(conn, :index, conn.assigns.project.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, project_id: conn.assigns.project.id)
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

  def assign_project(conn, _opts) do
    %{params: %{"project_id" => project_id}} = conn
    project = Repo.get(Flexphoenix.Project, project_id)
    assign(conn, :project, project)
  end
end
