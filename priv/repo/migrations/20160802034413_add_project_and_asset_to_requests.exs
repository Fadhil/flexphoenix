defmodule Flexcility.Repo.Migrations.AddSiteAndAssetToRequests do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :site_id, references(:sites)
      add :asset_id, references(:assets)
    end

    create index(:requests, [:site_id])
    create index(:requests, [:asset_id])
  end
end
