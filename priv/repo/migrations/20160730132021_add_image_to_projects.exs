defmodule Flexcility.Repo.Migrations.AddImageToSites do
  use Ecto.Migration

  def change do
    alter table(:sites) do
      add :image, :string
    end
  end
end
