defmodule Flexphoenix.Repo.Migrations.CreateAsset do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string
      add :model_id, :string
      add :manufacturer, :string
      add :photo, :string
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps
    end
    create index(:assets, [:project_id])

  end
end
