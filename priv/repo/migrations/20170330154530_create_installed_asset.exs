defmodule Flexcility.Repo.Migrations.CreateInstalledAsset do
  use Ecto.Migration

  def change do
    create table(:installed_assets) do
      add :installation_date, :datetime
      add :notes, :text
      add :asset_id, references(:assets, on_delete: :nothing)
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end
    create index(:installed_assets, [:asset_id])
    create index(:installed_assets, [:site_id])

  end
end
