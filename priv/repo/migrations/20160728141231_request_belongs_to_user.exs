defmodule Flexphoenix.Repo.Migrations.RequestBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :user_id, references(:users)
    end
  end
end
