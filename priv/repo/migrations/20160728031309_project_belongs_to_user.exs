defmodule Flexcility.Repo.Migrations.SiteBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :user_id, references(:users)
    end
  end
end
