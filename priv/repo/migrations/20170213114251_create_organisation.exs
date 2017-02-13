defmodule Flexcility.Repo.Migrations.CreateOrganisation do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string
      add :display_name, :string
      add :logo, :string
      add :description, :text

      timestamps()
    end

  end
end
