defmodule Flexcility.Repo.Migrations.CreateSitesTraits do
  use Ecto.Migration

  def change do
    create table(:sites_traits, primary_key: false) do
      add :site_id, references(:sites, on_delete: :delete_all)
      add :trait_id, references(:traits, on_delete: :delete_all)
    end
  end
end
