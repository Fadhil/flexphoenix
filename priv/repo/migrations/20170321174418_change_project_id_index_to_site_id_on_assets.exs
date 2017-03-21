defmodule Flexcility.Repo.Migrations.ChangeProjectIdIndexToSiteIdOnAssets do
  use Ecto.Migration

  def change do
    drop index(:assets, [:project_id])
    create index(:assets, [:site_id])
  end
end
