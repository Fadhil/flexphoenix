defmodule Flexcility.InstalledAsset do
  use Flexcility.Web, :model

  schema "installed_assets" do
    field :installation_date, Ecto.DateTime
    field :notes, :string
    belongs_to :asset, Flexcility.Asset
    belongs_to :site, Flexcility.Site

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:installation_date, :notes])
  end
end
