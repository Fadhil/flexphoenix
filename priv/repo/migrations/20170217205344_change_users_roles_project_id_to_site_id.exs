defmodule Flexcility.Repo.Migrations.ChangeUsersRolesProjectIdToSiteId do
  use Ecto.Migration

  def change do
    rename table(:users_roles), :project_id, to: :site_id
  end
end
