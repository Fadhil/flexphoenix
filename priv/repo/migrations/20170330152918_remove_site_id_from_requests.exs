defmodule Flexcility.Repo.Migrations.RemoveSiteIdFromRequests do
  use Ecto.Migration

  def up do
    alter table(:requests) do
      remove :site_id
    end
  end

  def down do
    alter table(:requests) do
      add :site_id, references(:sites)
    end
  end
end
