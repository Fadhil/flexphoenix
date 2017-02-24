defmodule Flexcility.Repo.Migrations.AddSiteIdToUsersRoles do
  use Ecto.Migration

  def change do
    alter table(:users_roles) do
      add :site_id, references(:projects, on_delete: :nothing)
    end
    create index(:users_roles, [:project_id])
  end
end
