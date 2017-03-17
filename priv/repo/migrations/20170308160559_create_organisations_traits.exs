defmodule Flexcility.Repo.Migrations.CreateOrganisationsTraits do
  use Ecto.Migration

  def change do
    create table(:organisations_traits, primary_key: false) do
      add :organisation_id, references(:organisations, on_delete: :delete_all)
      add :trait_id, references(:traits, on_delete: :delete_all)
    end
  end
end
