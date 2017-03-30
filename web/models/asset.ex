defmodule Flexcility.Asset do
  use Flexcility.Web, :model

  schema "assets" do
    field :name, :string
    field :model_id, :string
    field :manufacturer, :string
    field :photo, Flexcility.Image.Type
    has_many :installed_assets, Flexcility.InstalledAsset
    has_many :sites, through: [:installed_assets, :site]

    timestamps
  end

  @required_fields ~w(name model_id manufacturer )
  @optional_fields ~w()

  @required_file_fields ~w()
  @image_fields ~w(photo)
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> cast_attachments(params, @image_fields)
  end

  def create_changeset(model, site_id, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> put_site_id(site_id)
  end

  def put_site_id(changeset, site_id) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :site_id, site_id)
      _ ->
        changeset
    end
  end

  def image_changeset(asset, params) do
    asset
    |> cast_attachments(params, @image_fields)
  end

  def with_project(query) do
    from q in query, preload: [:site]
  end
end
