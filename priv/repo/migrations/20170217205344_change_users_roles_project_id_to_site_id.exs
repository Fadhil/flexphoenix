defmodule Flexcility.Repo.Migrations.ChangeUsersRolesProjectIdToSiteId do
  use Ecto.Migration

  def change do
    rename table(:users_roles), :site_id, to: :site_id
  end
end
