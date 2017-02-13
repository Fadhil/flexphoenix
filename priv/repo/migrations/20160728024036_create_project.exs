defmodule Flexcility.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :description, :text
      add :address, :text

      timestamps
    end

  end
end
