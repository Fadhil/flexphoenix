defmodule Flexcility.Repo.Migrations.AddUserReferencesToOrganisationsTable do
  use Ecto.Migration

  def change do
    alter table(:organisations) do
      add :user_id, references(:users)
    end
  end
end
