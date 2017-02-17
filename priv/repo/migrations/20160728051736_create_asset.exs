defmodule Flexcility.Repo.Migrations.CreateAsset do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string
      add :model_id, :string
      add :manufacturer, :string
      add :photo, :string
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps
    end
    create index(:assets, [:site_id])

  end
end
