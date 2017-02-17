defmodule Flexcility.Repo.Migrations.AddSiteIdToUsersRoles do
  use Ecto.Migration

  def change do
    alter table(:users_roles) do
      add :site_id, references(:sites, on_delete: :nothing)
    end
    create index(:users_roles, [:site_id])
  end
end
