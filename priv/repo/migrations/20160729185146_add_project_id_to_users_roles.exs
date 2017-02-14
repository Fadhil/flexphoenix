defmodule Flexcility.Repo.Migrations.AddProjectIdToUsersRoles do
  use Ecto.Migration

  def change do
    alter table(:users_roles) do
      add :project_id, references(:projects, on_delete: :nothing)
    end
    create index(:users_roles, [:project_id])
  end
end
