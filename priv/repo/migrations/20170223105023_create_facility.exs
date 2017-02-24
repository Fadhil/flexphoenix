defmodule Flexcility.Repo.Migrations.CreateFacility do
  use Ecto.Migration

  def change do
    create table(:facilities) do
      add :name, :string
      add :icon_name, :string

      timestamps()
    end

  end
end
