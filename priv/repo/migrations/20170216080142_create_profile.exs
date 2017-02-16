defmodule Flexcility.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :full_name, :string
      add :image, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:profiles, [:user_id])

  end
end
