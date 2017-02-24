defmodule Flexcility.Repo.Migrations.AddSiteAndAssetToRequests do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :project_id, references(:project)
      add :asset_id, references(:assets)
    end

    create index(:requests, [:project_id])
    create index(:requests, [:asset_id])
  end
end
