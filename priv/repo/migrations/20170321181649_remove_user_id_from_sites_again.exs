defmodule Flexcility.Repo.Migrations.RemoveUserIdFromSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      remove :user_id
    end
  end
end
