defmodule Flexphoenix.Repo.Migrations.CreateAssignedTechniciansTable do
  use Ecto.Migration

  def change do
    create table(:assigned_technicians) do
      add :user_id, references(:users, on_delete: :nothing)
      add :request_id, references(:requests, on_delete: :nothing)
      add :order_id, references(:orders, on_delete: :nothing)
      timestamps
    end

    create index(:assigned_technicians, [:user_id, :request_id])
    create index(:assigned_technicians, [:user_id, :order_id])
  end
end
