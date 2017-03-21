defmodule Flexcility.Repo.Migrations.ChangeIndexProjectToIndexSiteOnRequests do
  use Ecto.Migration

  def change do
    drop index(:requests, [:project_id])
    create index(:requests, [:site_id])
  end
end
