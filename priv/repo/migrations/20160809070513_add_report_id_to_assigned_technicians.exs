defmodule Flexcility.Repo.Migrations.AddReportIdToAssignedTechnicians do
  use Ecto.Migration

  def change do
    alter table(:assigned_technicians) do
      add :report_id, references(:reports, on_delete: :nothing)
    end

    create index(:assigned_technicians, [:user_id, :report_id])
  end
end
