defmodule Flexphoenix.Repo.Migrations.OrderBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:order) do
      add :user_id, references(:users)
    end
  end

end
