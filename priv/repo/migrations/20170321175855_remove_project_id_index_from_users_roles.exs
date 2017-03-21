defmodule Flexcility.Repo.Migrations.RemoveProjectIdIndexFromUsersRoles do
  use Ecto.Migration

  def change do
    drop index(:users_roles, [:project_id])
  end
end
