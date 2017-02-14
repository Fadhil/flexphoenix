defmodule Flexcility.Repo.Migrations.ReportBelongsToOrder do
  use Ecto.Migration

  def change do
    alter table(:reports) do
      add :order_id, references(:orders)
    end

    create index(:reports, [:order_id])
  end
end
