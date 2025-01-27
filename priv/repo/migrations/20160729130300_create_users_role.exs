defmodule Flexcility.Repo.Migrations.CreateUsersRole do
  use Ecto.Migration

  def change do
    create table(:users_roles) do
      add :user_id, references(:users, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps
    end
    create index(:users_roles, [:user_id])
    create index(:users_roles, [:role_id])

  end
end
