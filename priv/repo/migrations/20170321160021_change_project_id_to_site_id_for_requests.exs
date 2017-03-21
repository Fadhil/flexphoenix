defmodule Flexcility.Repo.Migrations.ChangeProjectIdToSiteIdForRequests do
  use Ecto.Migration

  def change do
    rename table(:requests), :project_id, to: :site_id
  end
end
