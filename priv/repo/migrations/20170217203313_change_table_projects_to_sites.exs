defmodule Flexcility.Repo.Migrations.ChangeTableProjectsToSites do
  use Ecto.Migration

  def change do
    rename table(:projects), to: table(:sites)
  end
end
