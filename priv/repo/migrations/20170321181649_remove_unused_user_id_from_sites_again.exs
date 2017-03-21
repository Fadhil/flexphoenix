defmodule Flexcility.Repo.Migrations.RemoveUnusedUserIdFromSitesAgain do
  use Ecto.Migration

  def up do
    alter table(:sites) do
      remove :user_id
    end
  end

  def down do
    alter table(:sites) do
      add :user_id, :integer
    end
  end
end
