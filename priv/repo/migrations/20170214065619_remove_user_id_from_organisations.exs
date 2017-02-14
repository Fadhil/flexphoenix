defmodule Flexcility.Repo.Migrations.RemoveUserIdFromOrganisations do
  use Ecto.Migration

  def up do
    alter table(:organisations) do
      remove :user_id
    end

    drop_index(:organisations, [:user_id])
  end

  def down do
    alter table(:organisations) do
      add :user_id, references(:users)
    end
  end
end
