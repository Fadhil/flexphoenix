defmodule Flexcility.Repo.Migrations.CreateMembership do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users, on_delete: :nothing)
      add :organisation_id, references(:organisations, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end
    create index(:memberships, [:user_id])
    create index(:memberships, [:organisation_id])
    create index(:memberships, [:role_id])

  end
end
