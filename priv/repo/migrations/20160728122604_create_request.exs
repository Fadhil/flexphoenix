defmodule Flexcility.Repo.Migrations.CreateRequest do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :worktype, :string
      add :title, :string
      add :location, :text
      add :description, :text

      timestamps
    end

  end
end
