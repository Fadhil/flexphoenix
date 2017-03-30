defmodule Flexcility.Repo.Migrations.RemoveSiteIdFromAssets do
  use Ecto.Migration

  def up do
    alter table(:assets) do
      remove :site_id
    end
    # drop index(:assets, [:site_id])
  end

  def down do
    alter table(:assets) do
      add :site_id, references(:sites)
    end
    # create index(:assets, [:site_id])
  end
end
