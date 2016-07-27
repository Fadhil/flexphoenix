defmodule Flexphoenix.Repo.Migrations.RemoveNameFromUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      remove(:name)
    end
  end

  def down do
    alter table(:users) do
      add :name, :string
    end
  end
end
