defmodule Flexcility.Repo.Migrations.CreateAsset do
  use Ecto.Migration

  def change do
    create table(:assets) do

      timestamps()
    end

  end
end
