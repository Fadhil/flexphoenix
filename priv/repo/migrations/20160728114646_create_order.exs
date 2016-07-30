defmodule Flexphoenix.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :title, :string
      add :body, :text

      timestamps
    end

  end
end
