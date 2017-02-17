defmodule Flexcility.Repo.Migrations.ChangeAssetsProjectIdToSiteId do
  use Ecto.Migration

  def change do
    rename table(:assets), :project_id, to: :site_id
  end
end
