defmodule Flexcility.Repo.Migrations.AddSubdomainFieldToOrganisations do
  use Ecto.Migration

  def change do
    alter table(:organisations) do
      add :subdomain, :string
    end

    create unique_index(:organisations, [:subdomain])
  end
end
