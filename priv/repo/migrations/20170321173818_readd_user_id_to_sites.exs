defmodule Flexcility.Repo.Migrations.ReaddUserIdToSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :user_id, :integer
    end
  end
end
