defmodule Flexcility.Repo.Migrations.AddOrganisationSubdomainToInvitations do
  use Ecto.Migration

  def change do
    alter table(:invitations) do
      add :organisation_subdomain, :string
    end
  end
end
