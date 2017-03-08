defmodule Flexcility.Repo.Migrations.CreateFacilitiesOrganisationsTable do
  use Ecto.Migration

  def change do
    create table(:facilities_organisations, primary_key: false) do
      add :facility_id, references(:facilities, on_delete: :delete_all)
      add :organisation_id, references(:organisations, on_delete: :delete_all)
    end
  end
end
