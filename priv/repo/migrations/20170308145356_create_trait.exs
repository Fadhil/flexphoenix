defmodule Flexcility.Repo.Migrations.CreateTrait do
  use Ecto.Migration

  def change do
    create table(:traits) do
      add :name, :string
      add :code, :string
      add :abbreviation, :string

      timestamps()
    end

  end
end
