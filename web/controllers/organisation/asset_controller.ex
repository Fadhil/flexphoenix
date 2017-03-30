defmodule Flexcility.Organisation.AssetController do
  use Flexcility.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Flexcility.Asset
  alias Flexcility.InstalledAsset
  plug Flexcility.Plugs.AssignOrganisation

  plug :scrub_params, "asset" when action in [:create, :update]
  plug :assign_project

  def index(conn, _params) do
    %{"site_id" => site_id} = conn.params
    site_id = String.to_integer(site_id)
    query = from a in Asset,
            join: p in assoc(a, :sites),
            where: p.id == ^site_id,
            preload: [sites: p]
    assets = Repo.all(query)

    render(conn, assets: assets, page_title: conn.assigns.organisation.name)
  end

  def new(conn, _params) do
    assets = Repo.all(Asset) |> Enum.map(&({"#{&1.name} - #{&1.model_id}", &1.id }))
    changeset = InstalledAsset.changeset(%InstalledAsset{})
    render(conn, "new.html", assets: assets, changeset: changeset, page_title: conn.assigns.organisation.name)
  end

  def create(conn, %{"asset" => asset_params}) do
    changeset = Asset.create_changeset(%Asset{}, conn.assigns.site.id, asset_params)

    case Repo.insert(changeset) do
      {:ok, asset} ->
        Asset.image_changeset(asset, asset_params)
        |> Repo.update
        conn
        |> put_flash(:info, "Asset created successfully.")
        |> redirect(to: organisation_site_asset_path(conn, :index, conn.assigns.organisation, conn.assigns.site))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, site_id: conn.assigns.site.id)
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
        |> redirect(to: organisation_site_asset_path(conn, :show, conn.assigns.organisation, conn.assigns.site.id, asset))
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
    |> redirect(to: organisation_site_asset_path(conn, :index, conn.assigns.organsation, conn.assigns.site.id))
  end

  def assign_project(conn, _opts) do
    %{params: %{"site_id" => site_id}} = conn
    project = Repo.get(Flexcility.Site, site_id)
    assign(conn, :site, project)
  end
end
