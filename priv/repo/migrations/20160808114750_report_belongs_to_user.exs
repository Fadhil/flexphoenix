defmodule Flexcility.Repo.Migrations.ReportBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:reports) do
      add :user_id, references(:users)
    end
  end
end
