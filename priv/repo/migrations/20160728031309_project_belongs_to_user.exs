defmodule Flexcility.Repo.Migrations.ProjectBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :user_id, references(:users)
    end
  end
end
