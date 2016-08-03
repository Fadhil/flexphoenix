defmodule Flexphoenix.Repo.Migrations.AddFieldsToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :description, :text
      add :location, :string
      add :type, :string
      add :instruction, :text
      add :priority, :string
      add :deadline, :string
    end
  end
end
