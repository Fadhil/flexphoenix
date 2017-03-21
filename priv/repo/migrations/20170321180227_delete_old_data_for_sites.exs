defmodule Flexcility.Repo.Migrations.DeleteOldDataForSites do
  use Ecto.Migration

  def change do
    execute "DELETE FROM users_roles"
    execute "DELETE FROM assets"
    execute "DELETE FROM sites"
  end
end
