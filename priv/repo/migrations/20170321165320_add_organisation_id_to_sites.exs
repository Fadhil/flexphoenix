defmodule Flexcility.Repo.Migrations.AddOrganisationIdToSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :organisation_id, references(:organisations)
    end
  end
end
