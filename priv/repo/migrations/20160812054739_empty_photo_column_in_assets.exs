defmodule Flexcility.Repo.Migrations.EmptyPhotoColumnInAssets do
  use Ecto.Migration

  def up do
    alter table(:assets) do
      remove :photo
      add :photo, :string
    end
  end

  def down do

  end
end
