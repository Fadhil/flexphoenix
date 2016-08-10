defmodule Flexphoenix.Repo.Migrations.AddRequestIdToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :request_id, references(:requests)
    end

    create index(:orders, [:request_id])
  end
end
