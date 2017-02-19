defmodule Flexcility.Repo.Migrations.ChangeTableProjectsToSites do
  use Ecto.Migration

  def change do
    rename table(:sites), to: table(:sites)
  end
end
